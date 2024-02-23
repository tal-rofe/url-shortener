import { z } from 'zod';

const RequestBody = z.object({
	url: z.string({ invalid_type_error: '"url" key must be of type string' }).url({ message: 'Invalid URL' }),
});

export default RequestBody;
