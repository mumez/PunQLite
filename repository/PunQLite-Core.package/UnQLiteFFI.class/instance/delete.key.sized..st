actions
delete: dbHandle key: key sized: keySize
	^self ffiCall: #( int unqlite_kv_delete( db_ptr dbHandle, void* key, int keySize) )