actions
fetch: dbHandle key: key sized: keySize value: value sized: valueSize
	^ self ffiCall: #( int unqlite_kv_fetch( db_ptr dbHandle, void* key, int keySize, void* value, bufSize_holder valueSize) )