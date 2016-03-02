actions
fetch: dbHandle key: key sized: keySize callback: callback
	^ self ffiCall: #( int unqlite_kv_fetch_callback( db_ptr dbHandle, void* key, int keySize, UnQLiteFetchCallback callback, 0) ) options: #( optMayGC )