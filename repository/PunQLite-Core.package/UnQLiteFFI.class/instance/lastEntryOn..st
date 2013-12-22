actions-cursor
lastEntryOn: cursorHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_cursor_last_entry(cursor_ptr cursorHandle) ) module: #unqlite