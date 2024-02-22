import path from 'node:path';

import react from '@vitejs/plugin-react';
import { defineConfig } from 'vite';
import tsconfigPaths from 'vite-tsconfig-paths';
import sassDts from 'vite-plugin-sass-dts';

export default defineConfig(() => {
	return {
		server: {
			port: 8080,
		},
		base: '/',
		build: { outDir: './dist' },
		plugins: [react(), tsconfigPaths(), sassDts()],
		resolve: { alias: { '@/styles': path.join(__dirname, 'src', 'styles') } },
		preview: { port: 8080 },
		mode: 'development',
	};
});
