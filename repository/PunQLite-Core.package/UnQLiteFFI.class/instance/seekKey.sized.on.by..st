actions-cursor
seekKey: key sized: keySize on: cursorHandle by: seekPosition
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_cursor_seek( cursor_ptr cursorHandle, void* key, int keySize, int seekPosition) ) module: #unqlite