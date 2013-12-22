actions-cursor
nextEntryOn: cursorHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_cursor_next_entry(cursor_ptr cursorHandle) ) module: #unqlite