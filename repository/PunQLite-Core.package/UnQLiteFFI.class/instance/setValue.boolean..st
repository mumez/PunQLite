jx9 - accessing
setValue: pValue boolean: anObject
	^ self ffiCall: #( int unqlite_value_bool( value_ptr pValue, int anObject) )