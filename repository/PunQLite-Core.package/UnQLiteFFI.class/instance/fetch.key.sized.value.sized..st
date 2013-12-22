actions
fetch: dbHandle key: key sized: keySize value: value sized: valueSize
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_fetch( db_ptr dbHandle, void* key, int keySize, void* value, NBInt64* valueSize) ) module: #unqlite