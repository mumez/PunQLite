jx9
resetStringCursor: pVal
	^ self ffiCall: #( int unqlite_value_reset_string_cursor( value_ptr pVal ) )