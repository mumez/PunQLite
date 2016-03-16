transactions
rollbackTransactionOn: dbHandle
	^ self ffiCall: #( int unqlite_rollback( db_ptr dbHandle) )