transactions
commitTransactionOn: dbHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_commit( db_ptr dbHandle) ) module: #unqlite