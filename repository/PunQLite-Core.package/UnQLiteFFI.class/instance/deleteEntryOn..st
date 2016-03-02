actions-cursor
deleteEntryOn: cursorHandle
	^ self ffiCall: #( int unqlite_kv_cursor_delete_entry(cursor_ptr cursorHandle) )