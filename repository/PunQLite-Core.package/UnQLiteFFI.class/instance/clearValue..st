jx9
clearValue: pValue
	^ self ffiCall: #( int unqlite_value_null( value_ptr pValue) )