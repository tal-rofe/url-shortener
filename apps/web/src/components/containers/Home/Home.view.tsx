import React, { type ForwardedRef, forwardRef } from 'react';

import classes from './Home.module.scss';

type Props = {
	readonly isOutputButtonDisabled: boolean;
	readonly onClickButtonShorten: VoidFunction;
	readonly onClickButtonOutput: VoidFunction;
};

const HomeView = forwardRef((props: Props, urlInputRef: ForwardedRef<HTMLInputElement>) => {
	return (
		<main className={classes['container']}>
			<h1 className={classes['container__header']}>URL Shortener</h1>

			<div className={classes['urlInputContainer']}>
				<input
					className={classes['urlInputContainer__input']}
					ref={urlInputRef}
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
