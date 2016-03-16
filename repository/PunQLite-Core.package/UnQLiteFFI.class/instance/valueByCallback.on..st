actions-cursor
valueByCallback: callback on: cursorHandle
	^ self ffiCall: #( int unqlite_kv_cursor_data_callback( cursor_ptr cursorHandle, UnQLiteFetchCallback callback, 0) ) options: #( optMayGC )