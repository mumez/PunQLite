jx9 - result
result: pCtx resource: pUserData
	^ self ffiCall: #(unqlite_result_resource(context_ptr pCtx, void *pUserData))