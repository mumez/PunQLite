actions
delete: dbHandle key: key sized: keySize
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_delete( db_ptr dbHandle, void* key, int keySize) ) module: #unqlite