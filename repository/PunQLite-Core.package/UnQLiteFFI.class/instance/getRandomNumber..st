utilities
getRandomNumber: dbHandle
	^ self ffiCall: #( int unqlite_util_random_num( db_ptr dbHandle) )