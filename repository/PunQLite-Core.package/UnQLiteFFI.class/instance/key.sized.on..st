actions-cursor
key: key sized: keySize on: cursorHandle
	^ self ffiCall: #( int unqlite_kv_cursor_key( cursor_ptr cursorHandle, void* key, int* keySize) )