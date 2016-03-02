utilities
getRandomString: dbHandle into: value sized: valueSize
	^ self ffiCall: #( int unqlite_util_random_string( db_ptr dbHandle, char* value, uint valueSize) )