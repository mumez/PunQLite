jx9 - testing
isResource: pValue
	^ self ffiCall: #( int unqlite_value_is_resource(value_ptr pValue) )