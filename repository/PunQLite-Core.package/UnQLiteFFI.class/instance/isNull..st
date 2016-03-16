jx9 - testing
isNull: pValue
	^ self ffiCall: #( int unqlite_value_is_null(value_ptr pValue) )