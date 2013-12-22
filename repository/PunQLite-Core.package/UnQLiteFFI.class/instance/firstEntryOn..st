actions-cursor
firstEntryOn: cursorHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_cursor_first_entry(cursor_ptr cursorHandle) ) module: #unqlite