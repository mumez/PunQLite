transactions
rollbackTransactionOn: dbHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_rollback( db_ptr dbHandle) ) module: #unqlite