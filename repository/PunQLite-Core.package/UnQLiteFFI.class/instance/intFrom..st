jx9 - init/release
intFrom: pValue
	^ self ffiCall: #( int unqlite_value_to_int( value_ptr pValue ) )