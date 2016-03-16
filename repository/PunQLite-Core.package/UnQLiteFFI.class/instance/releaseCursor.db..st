actions-cursor
releaseCursor: cursorHandle db: dbHandle
	^ self ffiCall: #( int unqlite_kv_cursor_release(cursor_ptr dbHandle, FFIExternalObject cursorHandle) )