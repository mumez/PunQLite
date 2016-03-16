transactions
commitTransactionOn: dbHandle
	^ self ffiCall: #( int unqlite_commit( db_ptr dbHandle) )