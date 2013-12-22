utilities
getRandomString: dbHandle into: value sized: valueSize
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_util_random_string( db_ptr dbHandle, char* value, uint valueSize) ) module: #unqlite