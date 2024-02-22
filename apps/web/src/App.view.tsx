import React, { useMemo } from 'react';
import { RouterProvider, createBrowserRouter } from 'react-router-dom';

import RouterBuilder from './App.router';

const AppView = () => {
	const routes = useMemo(() => RouterBuilder(), []);

	return <RouterProvider router={createBrowserRouter(routes)} />;
};

export default React.memo(AppView);
