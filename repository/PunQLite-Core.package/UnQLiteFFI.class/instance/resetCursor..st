actions-cursor
resetCursor: cursorHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_cursor_reset(cursor_ptr cursorHandle) ) module: #unqlite