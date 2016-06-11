jx9 - result
result: pCtx int64: iValue
	^ self ffiCall: #(unqlite_result_int64(context_ptr pCtx, int64 iValue))