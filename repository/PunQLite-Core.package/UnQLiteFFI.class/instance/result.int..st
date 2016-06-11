jx9 - result
result: pCtx int: iValue
	^ self ffiCall: #(unqlite_result_int(context_ptr pCtx, int iValue))