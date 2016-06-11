jx9 - conversion
resourceFrom: pValue
	^ self ffiCall: #( void *unqlite_value_to_resource( value_ptr pValue ) )