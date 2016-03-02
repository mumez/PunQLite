jx9 - testing
isString: pValue
	^ self ffiCall: #( int unqlite_value_is_string(value_ptr pValue) )