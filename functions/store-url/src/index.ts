import crypto from 'node:crypto';

import type { APIGatewayProxyHandler } from 'aws-lambda';
import type { z } from 'zod';
import { DynamoDBClient, GetItemCommand, PutItemCommand } from '@aws-sdk/client-dynamodb';

import RequestBody from './schemas/request-body';
import { MAX_ATTEMPTS } from './constants/dynamo-db';

export const handler: APIGatewayProxyHandler = async (event) => {
	const requestBody = event.body;

	console.log(`Request body is: ${requestBody}`);

	if (!requestBody) {
		return { statusCode: 400, body: JSON.stringify({ message: 'Missing URL to shortener' }) };
	}

	let validatedRequestBody: z.infer<typeof RequestBody>;

	try {
		const parsedRequestBody = JSON.parse(requestBody);
		validatedRequestBody = await RequestBody.parseAsync(parsedRequestBody);
	} catch (error: unknown) {
		return { statusCode: 400, body: JSON.stringify('Invalid URL data') };
	}

	/**
	 * * Hash the URL using injective function to map any URL to unique hashed value. 2 effects:
	 * * 1. Shortened value for any given URL
	 * * 2. No URL duplicates because function is injective
	 */
	const hashedUrl = crypto.createHash('md5').update(validatedRequestBody.url).digest('base64url');

	console.log(`Generated hashed URL: ${hashedUrl}`);

	const dynamoDbClient = new DynamoDBClient({ region: process.env.AWS_REGION, maxAttempts: MAX_ATTEMPTS });
	const getItemCommand = new GetItemCommand({
		TableName: process.env.DYNAMO_DB_TABLE_NAME,
		Key: {
			hash: { S: hashedUrl },
		},
	});

	let itemDoesExist: boolean;

	try {
		const result = await dynamoDbClient.send(getItemCommand);

		itemDoesExist = result.Item !== undefined;
	} catch (error: unknown) {
		console.log(`Failed to get item from DynamoDB with an error: ${error}`);

		itemDoesExist = false;
	}

	console.log(`Tried to get item from DynamoDB, got existence value: ${itemDoesExist}`);

	if (itemDoesExist) {
		console.log('URL was already shortened, return hash value');

		return {
			statusCode: 200,
			body: JSON.stringify({ hashedUrl, message: 'Successfully shortened URL' }),
		};
	}

	const putItemCommand = new PutItemCommand({
		TableName: process.env.DYNAMO_DB_TABLE_NAME,
		Item: {
			hash: { S: hashedUrl },
			url: { S: validatedRequestBody.url },
		},
	});

	try {
		await dynamoDbClient.send(putItemCommand);
	} catch (error: unknown) {
		console.log(`Failed to store hashed URL in the table, with an error: ${error}`);

		return { statusCode: 500, body: JSON.stringify({ message: 'Server error' }) };
	}

	console.log('Successfully stored DynamoDB entry with hashed URL');

	return { statusCode: 200, body: JSON.stringify({ hashedUrl, message: 'Successfully shortened URL' }) };
};
