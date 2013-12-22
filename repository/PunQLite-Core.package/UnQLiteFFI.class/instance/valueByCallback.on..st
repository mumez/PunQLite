actions-cursor
valueByCallback: callback on: cursorHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_kv_cursor_data_callback( cursor_ptr cursorHandle, UnQLiteFetchCallback callback, 0) ) module: #unqlite options: #( optMayGC )