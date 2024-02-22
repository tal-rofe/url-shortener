import React from 'react';
import type { RouteObject } from 'react-router-dom';

import AppLayout from './App.layout';

const Home = React.lazy(() => import('./pages/Home'));

const RouterBuilder = () => {
	const unAuthorizedRoutes: RouteObject[] = [
		{
			path: '',
			element: <Home />,
		},
	];

	const generalRoutes: RouteObject[] = [
		{
			path: '*',
			element: <Home />,
		},
	];

	const routes: RouteObject[] = [
		{
			element: <AppLayout />,
			children: [...unAuthorizedRoutes, ...generalRoutes],
		},
	];

	return routes;
};

export default RouterBuilder;
