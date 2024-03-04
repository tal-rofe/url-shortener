import crypto from 'node:crypto';

import type { APIGatewayProxyHandler } from 'aws-lambda';
import type { z } from 'zod';
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';

import RequestBody from './schemas/request-body';
import { doesObjectExist } from './utils/s3';

export const handler: APIGatewayProxyHandler = async (event) => {
	const requestBody = event.body;

	console.log(`Request body is: ${requestBody}`);

	if (!requestBody) {
		return { statusCode: 400, body: 'Missing URL to shortener' };
	}

	let validatedRequestBody: z.infer<typeof RequestBody>;

	try {
		const parsedRequestBody = JSON.parse(requestBody);
		validatedRequestBody = await RequestBody.parseAsync(parsedRequestBody);
	} catch (error: unknown) {
		return { statusCode: 400, body: 'Invalid URL data' };
	}

	/**
	 * * Hash the URL using injective function to map any URL to unique hashed value. 2 effects:
	 * * 1. Shortened value for any given URL
	 * * 2. No URL duplicates because function is injective
	 */
	const hashedUrl = crypto.createHash('md5').update(validatedRequestBody.url).digest('base64url');

	console.log(`Generated hashed URL: ${hashedUrl}`);

	const s3Client = new S3Client({ region: process.env.AWS_REGION });
	const doesUrlExist = await doesObjectExist(s3Client, hashedUrl);

	if (doesUrlExist) {
		console.log('URL was already shortened, return hash value');

		return { statusCode: 200, body: JSON.stringify({ hashedUrl }) };
	}

	const putS3Command = new PutObjectCommand({
		Bucket: process.env.S3_BUCKET,
		Key: hashedUrl,
		WebsiteRedirectLocation: validatedRequestBody.url,
	});

	try {
		await s3Client.send(putS3Command);
	} catch (error: unknown) {
		console.log(`Failed to store hashed URL in the bucket, with an error: ${error}`);

		return { statusCode: 500, body: 'Server error' };
	}

	return { statusCode: 200, body: JSON.stringify({ hashedUrl }) };
};
