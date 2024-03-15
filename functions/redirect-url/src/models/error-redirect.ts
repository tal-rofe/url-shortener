export const errorRedirectReturnObject = {
	status: '301',
	statusDescription: 'Moved Permanently',
	headers: {
		'location': [
			{
				key: 'Location',
				value: 'https://url-shortener-guide.click/',
			},
		],
		'cache-control': [
			{
				key: 'Cache-Control',
				value: 'max-age=3600',
			},
		],
	},
};
