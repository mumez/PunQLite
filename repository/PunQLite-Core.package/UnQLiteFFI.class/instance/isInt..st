jx9 - testing
isInt: pValue
	^ self ffiCall: #( int unqlite_value_is_int(value_ptr pValue) )