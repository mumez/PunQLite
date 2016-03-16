actions
open: dbHandle named: dbName mode: mode
	^ self ffiCall: #( int unqlite_open( db_ptr* dbHandle, String dbName, uint mode) )