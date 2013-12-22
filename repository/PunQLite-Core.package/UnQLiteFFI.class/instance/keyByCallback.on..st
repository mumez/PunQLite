actions-cursor
keyByCallback: callback on: cursorHandle 
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_cursor_key_callback( cursor_ptr cursorHandle, UnQLiteFetchCallback callback, 0) ) module: #unqlite options: #( optMayGC )