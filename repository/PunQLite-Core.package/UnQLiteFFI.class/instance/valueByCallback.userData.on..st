actions-cursor
valueByCallback: callback userData: userData on: cursorHandle
	^ self ffiCall: #( int unqlite_kv_cursor_data_callback( cursor_ptr cursorHandle, UnQLiteFetchCallback callback, void* userData) ) options: #( optMayGC )