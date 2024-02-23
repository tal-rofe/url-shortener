import { type S3Client, HeadObjectCommand } from '@aws-sdk/client-s3';

export const doesObjectExist = async (s3Client: S3Client, objectKey: string) => {
	const headCommand = new HeadObjectCommand({
		Bucket: process.env.S3_BUCKET,
		Key: objectKey,
	});

	try {
		await s3Client.send(headCommand);

		return true;
	} catch (error: unknown) {
		return false;
	}
};
