jx9 - testing
isScalar: pValue
	^ self ffiCall: #( int unqlite_value_is_scalar(value_ptr pValue) )