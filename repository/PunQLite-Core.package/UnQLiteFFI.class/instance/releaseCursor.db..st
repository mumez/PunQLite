actions-cursor
releaseCursor: cursorHandle db: dbHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_cursor_release(cursor_ptr dbHandle, NBExternalObject cursorHandle) ) module: #unqlite