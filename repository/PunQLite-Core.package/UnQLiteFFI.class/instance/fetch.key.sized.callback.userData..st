actions
fetch: dbHandle key: key sized: keySize callback: callback userData: userData
	^ self ffiCall: #( int unqlite_kv_fetch_callback( db_ptr dbHandle, void* key, int keySize, UnQLiteFetchCallback callback, void* userData) )