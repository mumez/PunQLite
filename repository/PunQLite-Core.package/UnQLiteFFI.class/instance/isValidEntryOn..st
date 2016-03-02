actions-cursor
isValidEntryOn: cursorHandle
	^ self ffiCall: #( int unqlite_kv_cursor_valid_entry(cursor_ptr cursorHandle) )