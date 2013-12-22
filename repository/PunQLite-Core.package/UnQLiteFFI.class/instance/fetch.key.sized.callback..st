actions
fetch: dbHandle key: key sized: keySize callback: callback
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_fetch_callback( db_ptr dbHandle, void* key, int keySize, UnQLiteFetchCallback callback, 0) ) module: #unqlite options: #( optMayGC )