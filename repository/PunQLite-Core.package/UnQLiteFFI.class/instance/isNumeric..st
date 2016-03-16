jx9 - testing
isNumeric: pValue
	^ self ffiCall: #( int unqlite_value_is_numeric(value_ptr pValue) )