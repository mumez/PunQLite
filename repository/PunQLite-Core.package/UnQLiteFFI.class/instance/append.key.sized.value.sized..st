actions
append: dbHandle key: key sized: keySize value: value sized: valueSize
	^ self ffiCall: #( int unqlite_kv_append( db_ptr dbHandle, void* key, int keySize, void* value, int64_t valueSize) )