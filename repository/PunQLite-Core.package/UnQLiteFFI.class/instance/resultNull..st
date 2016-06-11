jx9 - result
resultNull: pCtx
	^ self ffiCall: #(unqlite_result_null(context_ptr pCtx))