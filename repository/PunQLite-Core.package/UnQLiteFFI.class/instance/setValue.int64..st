jx9 - accessing
setValue: pValue int64: anInteger
	^ self ffiCall: #( int unqlite_value_int64( value_ptr pValue, int64_t anInteger) )