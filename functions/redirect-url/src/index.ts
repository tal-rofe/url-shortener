import type { CloudFrontRequestHandler } from 'aws-lambda';
import { DynamoDBClient, GetItemCommand, type GetItemCommandOutput } from '@aws-sdk/client-dynamodb';

import { MAX_ATTEMPTS } from './constants/dynamo-db';
import { errorRedirectReturnObject } from './models/error-redirect';

export const handler: CloudFrontRequestHandler = async (event) => {
	const request = event.Records[0]!.cf.request;

	if (request.method !== 'GET') {
		return errorRedirectReturnObject;
	}

	/**
	 *  * See example, https://docs.aws.amazon.com/lambda/latest/dg/lambda-edge.html
	 *  * Thus, need to remove prefix of "/"
	 */
	const hashedUrl = request.uri.slice(1);

	console.log(`Hash URL is: ${hashedUrl}`);

	if (!hashedUrl) {
		console.log('Hash URL is empty, redirect to web application');

		return errorRedirectReturnObject;
	}

	const dynamoDbClient = new DynamoDBClient({ region: process.env.AWS_REGION, maxAttempts: MAX_ATTEMPTS });
	const getItemCommand = new GetItemCommand({
		TableName: process.env.DYNAMO_DB_TABLE_NAME,
		Key: {
			hash: { S: hashedUrl },
		},
	});

	let result: GetItemCommandOutput;

	try {
		result = await dynamoDbClient.send(getItemCommand);
	} catch (error: unknown) {
		console.log(`Failed to get item from DynamoDB with an error: ${error}`);

		return errorRedirectReturnObject;
	}

	if (!result.Item) {
		console.log('Hashed URL does not exist in DynamoDB table, redirect to web application');

		return errorRedirectReturnObject;
	}

	console.log(`Found hashed URL in DynamoDB table with value: ${JSON.stringify(result.Item)}`);

	return {
		status: '301',
		statusDescription: 'Moved Permanently',
		headers: {
			'location': [
				{
					key: 'Location',
					value: result.Item['url']!.S!,
				},
			],
			'cache-control': [
				{
					key: 'Cache-Control',
					value: 'max-age=3600',
				},
			],
		},
	};
};
