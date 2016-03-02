jx9 - conversion
int64From: pValue
	^ self ffiCall: #( int64 unqlite_value_to_int64( value_ptr pValue) )