declare global {
	namespace NodeJS {
		interface ProcessEnv {
			readonly AWS_REGION: string;
			readonly S3_BUCKET: string;
		}
	}
}

export {};
