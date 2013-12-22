actions-cursor
previousEntryOn: cursorHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_cursor_prev_entry(cursor_ptr cursorHandle) ) module: #unqlite