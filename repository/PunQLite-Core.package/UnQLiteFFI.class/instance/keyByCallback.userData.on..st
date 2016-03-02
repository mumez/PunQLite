actions-cursor
keyByCallback: callback userData: userData on: cursorHandle 
	^ self 
		ffiCall: #( int unqlite_kv_cursor_key_callback( cursor_ptr cursorHandle, UnQLiteFetchCallback callback, void* userData) ) 
		options: #( optMayGC )