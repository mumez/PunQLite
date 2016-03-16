actions
store: dbHandle key: key sized: keySize value: value sized: valueSize
	^ self ffiCall: #( int unqlite_kv_store( db_ptr dbHandle, void* key, int keySize, void* value, int64_t valueSize) )