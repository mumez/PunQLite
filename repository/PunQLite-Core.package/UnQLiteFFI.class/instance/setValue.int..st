jx9 - accessing
setValue: pValue int: anInteger
	^ self ffiCall: #( int unqlite_value_int( value_ptr pValue, int anInteger) )