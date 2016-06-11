jx9 - result
result: pCtx double: dValue
	^ self ffiCall: #(unqlite_result_double(context_ptr pCtx, double dValue))