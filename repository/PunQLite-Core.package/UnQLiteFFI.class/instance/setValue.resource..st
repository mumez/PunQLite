jx9 - accessing
setValue: pValue resource: pUserData
	^ self ffiCall: #( int unqlite_value_resource( value_ptr pValue, void *pUserData) )