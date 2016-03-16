actions-cursor
keyByCallback: callback on: cursorHandle 
	^ self 
		ffiCall: #( int unqlite_kv_cursor_key_callback( cursor_ptr cursorHandle, UnQLiteFetchCallback callback, 0) ) 
		options: #( optMayGC )