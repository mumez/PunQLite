actions-cursor
keyByCallback: callback userData: userData on: cursorHandle 
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_cursor_key_callback( cursor_ptr cursorHandle, UnQLiteFetchCallback callback, void* userData) ) module: #unqlite options: #( optMayGC )