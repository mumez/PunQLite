actions-cursor
seekKey: key sized: keySize on: cursorHandle by: seekPosition
	^ self ffiCall: #( int unqlite_kv_cursor_seek( cursor_ptr cursorHandle, void* key, int keySize, int seekPosition) )