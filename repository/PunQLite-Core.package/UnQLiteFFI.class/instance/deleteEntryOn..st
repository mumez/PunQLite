actions-cursor
deleteEntryOn: cursorHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_cursor_delete_entry(cursor_ptr cursorHandle) ) module: #unqlite