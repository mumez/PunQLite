jx9 - result
result: pCtx value: pValue
	^ self ffiCall: #(unqlite_result_value(context_ptr pCtx, value_ptr pValue))