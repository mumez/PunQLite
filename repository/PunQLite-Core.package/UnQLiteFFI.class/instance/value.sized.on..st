actions-cursor
value: value sized: valueSize on: cursorHandle
	^ self ffiCall: #( int unqlite_kv_cursor_data( cursor_ptr cursorHandle, void* value, bufSize_holder valueSize) )