actions-cursor
value: value sized: valueSize on: cursorHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_cursor_data( cursor_ptr cursorHandle, void* value, int64_t* valueSize) ) module: #unqlite