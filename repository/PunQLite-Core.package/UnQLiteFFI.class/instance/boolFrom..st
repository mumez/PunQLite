jx9 - conversion
boolFrom: pValue
	^ self ffiCall: #( int unqlite_value_to_bool( value_ptr pValue) )