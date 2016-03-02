jx9 - accessing
setValue: pValue double: aFloat
	^ self ffiCall: #( int unqlite_value_double( value_ptr pValue, double aFloat) )