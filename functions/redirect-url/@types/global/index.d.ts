declare global {
	namespace NodeJS {
		interface ProcessEnv {
			readonly AWS_REGION: string;
			readonly DYNAMO_DB_TABLE_NAME: string;
		}
	}
}

export {};
