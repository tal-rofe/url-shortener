import React, { useRef, useState } from 'react';
import { toast } from 'react-toastify';

import HomeView from './Home.view';

const Home = () => {
	const [isOutputButtonDisabledState, setIsOutputButtonDisabledState] = useState<boolean>(true);

	const urlInputRef = useRef<HTMLInputElement>(null);

	const onClickButtonShorten = () => {
		if (urlInputRef.current === null) {
			return;
		}

		const url = urlInputRef.current.value;

		if (url === '') {
			return;
		}

		try {
			new URL(url);

			toast.success('Successfully shortened URL, click to copy!');

			urlInputRef.current.value = '';

			setIsOutputButtonDisabledState(() => false);
		} catch (error: unknown) {
			toast.error('Invalid URL');

			setIsOutputButtonDisabledState(() => true);
		}
	};

	const onClickButtonOutput = () => {
		toast.info('URL copied to clipboard!');
	};

	return (
		<HomeView
			ref={urlInputRef}
			isOutputButtonDisabled={isOutputButtonDisabledState}
			onClickButtonShorten={onClickButtonShorten}
			onClickButtonOutput={onClickButtonOutput}
		/>
	);
};

export default React.memo(Home);
