actions-cursor
releaseCursor: cursorHandle db: dbHandle
	^ self ffiCall: #( int unqlite_kv_cursor_release(db_ptr dbHandle, cursor_ptr cursorHandle) )