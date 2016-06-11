jx9 - result
result: pCtx string: zString
	^ self ffiCall: #(unqlite_result_string(context_ptr pCtx, String zString))