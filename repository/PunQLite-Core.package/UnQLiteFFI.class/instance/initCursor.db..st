actions-cursor
initCursor: cursorHandle db: dbHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_cursor_init(db_ptr dbHandle, cursor_ptr* cursorHandle) ) module: #unqlite