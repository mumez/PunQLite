actions
close: dbHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_close( db_ptr dbHandle) ) module: #unqlite