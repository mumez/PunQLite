actions-cursor
initCursor: cursorHandle db: dbHandle
	^ self ffiCall: #( int unqlite_kv_cursor_init(db_ptr dbHandle, cursor_ptr* cursorHandle))