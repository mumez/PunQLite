jx9 - testing
isBool: pValue
	^ self ffiCall: #( int unqlite_value_is_bool(value_ptr pValue) )