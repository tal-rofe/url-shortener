import React, { useRef, useState } from 'react';
import { toast } from 'react-toastify';

import type { ShortenUrlResponseBody, UrlRelatedRefs } from './types';

import HomeView from './Home.view';

const Home = () => {
	const [isOutputButtonDisabledState, setIsOutputButtonDisabledState] = useState<boolean>(true);

	const urlRelatedRefs = useRef<UrlRelatedRefs>(null);

	const onClickButtonShorten = async () => {
		if (urlRelatedRefs.current === null || urlRelatedRefs.current.input.value === '') {
			return;
		}

		urlRelatedRefs.current.output.innerHTML = 'Shortened result..';
		setIsOutputButtonDisabledState(() => true);

		let urlObject: URL;

		try {
			urlObject = new URL(urlRelatedRefs.current.input.value);
		} catch (error: unknown) {
			toast.error('Invalid URL');

			return;
		}

		const apiCallHeaders = new Headers();
		apiCallHeaders.append('Content-Type', 'application/json');

		let shortenUrlResponse: Response;

		try {
			shortenUrlResponse = await fetch(`https://api.${import.meta.env.VITE_DOMAIN_NAME}/shortener`, {
				method: 'POST',
				headers: apiCallHeaders,
				body: JSON.stringify({ url: urlObject.toString() }),
			});
		} catch (error: unknown) {
			toast.error('Network Error');

			return;
		}

		const responseBody = (await shortenUrlResponse.json()) as ShortenUrlResponseBody;

		if (!shortenUrlResponse.ok) {
			toast.error(responseBody.message);

			return;
		}

		urlRelatedRefs.current.output.innerHTML = `https://u.${import.meta.env.VITE_DOMAIN_NAME}/${responseBody.hashedUrl!}`;
		setIsOutputButtonDisabledState(() => false);
		toast.success('Successfully shortened URL, click to copy!');
	};

	const onClickButtonOutput = () => {
		navigator.clipboard.writeText(urlRelatedRefs.current!.output.innerHTML!);

		toast.info('URL copied to clipboard!');
	};

	return (
		<HomeView
			ref={urlRelatedRefs}
			isOutputButtonDisabled={isOutputButtonDisabledState}
			onClickButtonShorten={onClickButtonShorten}
			onClickButtonOutput={onClickButtonOutput}
		/>
	);
};

export default React.memo(Home);
