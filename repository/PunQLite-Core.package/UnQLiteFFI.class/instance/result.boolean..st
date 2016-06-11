jx9 - result
result: pCtx boolean: iBool
	^ self ffiCall: #(int unqlite_result_bool(context_ptr pCtx, bool iBool))