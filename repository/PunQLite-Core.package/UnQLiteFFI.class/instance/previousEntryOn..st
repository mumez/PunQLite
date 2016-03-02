actions-cursor
previousEntryOn: cursorHandle
	^ self ffiCall: #( int unqlite_kv_cursor_prev_entry(cursor_ptr cursorHandle) )