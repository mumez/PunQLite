transactions
beginTransactionOn: dbHandle
	^ self ffiCall: #( int unqlite_begin( db_ptr dbHandle) )