actions-cursor
nextEntryOn: cursorHandle
	^ self ffiCall: #( int unqlite_kv_cursor_next_entry(cursor_ptr cursorHandle) )