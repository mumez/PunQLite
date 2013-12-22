actions
store: dbHandle key: key sized: keySize value: value sized: valueSize
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_store( db_ptr dbHandle, void* key, int keySize, void* value, NBInt64 valueSize) ) module: #unqlite