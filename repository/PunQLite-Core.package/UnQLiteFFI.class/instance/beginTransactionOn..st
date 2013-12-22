transactions
beginTransactionOn: dbHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_begin( db_ptr dbHandle) ) module: #unqlite