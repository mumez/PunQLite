actions-cursor
resetCursor: cursorHandle
	^ self ffiCall: #( int unqlite_kv_cursor_reset( cursor_ptr cursorHandle ) )