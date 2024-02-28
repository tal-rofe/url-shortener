import React, { type ForwardedRef, forwardRef, useRef, useImperativeHandle } from 'react';

import type { UrlRelatedRefs } from './types';

import classes from './Home.module.scss';

type Props = {
	readonly isOutputButtonDisabled: boolean;
	readonly onClickButtonShorten: () => Promise<void>;
	readonly onClickButtonOutput: VoidFunction;
};

const HomeView = forwardRef((props: Props, urlRelatedRefs: ForwardedRef<UrlRelatedRefs>) => {
	const inputRef = useRef<NonNullable<UrlRelatedRefs>['input'] | null>(null);
	const outputRef = useRef<NonNullable<UrlRelatedRefs>['output'] | null>(null);

	useImperativeHandle(urlRelatedRefs, () => ({
		input: inputRef.current!,
		output: outputRef.current!,
	}));

	return (
		<main className={classes['container']}>
			<h1 className={classes['container__header']}>URL Shortener</h1>

			<div className={classes['urlInputContainer']}>
				<input
					className={classes['urlInputContainer__input']}
					ref={inputRef}
					type="text"
					placeholder="Enter URL to shorten.."
				/>
				<button
					className={classes['urlInputContainer__button']}
					type="button"
					onClick={props.onClickButtonShorten}
				>
					Shorten
				</button>
			</div>

			<button
				ref={outputRef}
				className={classes['container__output']}
				type="button"
				disabled={props.isOutputButtonDisabled}
				onClick={props.onClickButtonOutput}
			>
				Shortened result..
			</button>
		</main>
	);
});

export default React.memo(HomeView);
