import React, { Suspense } from 'react';
import { Outlet } from 'react-router-dom';
import { ToastContainer } from 'react-toastify';

const AppLayout = () => {
	return (
		<Suspense fallback={null}>
			<ToastContainer
				autoClose={2500}
				position="bottom-center"
				theme="dark"
				pauseOnHover={false}
				newestOnTop
				style={{ fontSize: '1.4rem' }}
			/>
			<Outlet />
		</Suspense>
	);
};

export default React.memo(AppLayout);
