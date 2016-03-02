actions
close: dbHandle
	^ self ffiCall: #( int unqlite_close( db_ptr dbHandle) )