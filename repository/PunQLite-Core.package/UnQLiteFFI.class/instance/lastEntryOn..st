actions-cursor
lastEntryOn: cursorHandle
	^ self ffiCall: #( int unqlite_kv_cursor_last_entry(cursor_ptr cursorHandle) )