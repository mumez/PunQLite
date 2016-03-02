jx9 - testing
isFloat: pValue
	^ self ffiCall: #( int unqlite_value_is_float(value_ptr pValue) )