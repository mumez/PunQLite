actions
fetch: dbHandle key: key sized: keySize callback: callback userData: userData
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_fetch_callback( db_ptr dbHandle, void* key, int keySize, UnQLiteFetchCallback callback, void* userData) ) module: #unqlite options: #( optMayGC )