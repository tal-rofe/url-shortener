export type UrlRelatedRefs = {
	readonly input: HTMLInputElement;
	readonly output: HTMLButtonElement;
} | null;

export type ShortenUrlResponseBody = {
	readonly message: string;
	readonly hashedUrl?: string;
};
