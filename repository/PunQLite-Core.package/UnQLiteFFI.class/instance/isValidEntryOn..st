actions-cursor
isValidEntryOn: cursorHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_cursor_valid_entry(cursor_ptr cursorHandle) ) module: #unqlite