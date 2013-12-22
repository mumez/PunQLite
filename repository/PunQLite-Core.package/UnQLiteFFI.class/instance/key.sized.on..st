actions-cursor
key: key sized: keySize on: cursorHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_cursor_key( cursor_ptr cursorHandle, void* key, int* keySize) ) module: #unqlite