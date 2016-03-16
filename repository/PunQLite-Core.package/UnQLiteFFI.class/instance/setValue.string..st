jx9 - accessing
setValue: pValue string: anObject
	^ self ffiCall: #( int unqlite_value_string( value_ptr pValue, String anObject, -1) )