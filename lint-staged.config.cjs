const lintStagedConfig = {
	'**/*.{ts,js,json,yaml}': 'prettier --write',
	'**/*.tf': 'terraform fmt',
};

module.exports = lintStagedConfig;
