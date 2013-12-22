actions
open: dbHandle named: dbName mode: mode
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_open( db_ptr* dbHandle, String dbName, uint mode) ) module: #unqlite