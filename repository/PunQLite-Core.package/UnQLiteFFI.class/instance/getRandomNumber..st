utilities
getRandomNumber: dbHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_util_random_num( db_ptr dbHandle) ) module: #unqlite