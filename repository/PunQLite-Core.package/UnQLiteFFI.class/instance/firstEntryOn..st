actions-cursor
firstEntryOn: cursorHandle
	^ self ffiCall: #( int unqlite_kv_cursor_first_entry(cursor_ptr cursorHandle) )