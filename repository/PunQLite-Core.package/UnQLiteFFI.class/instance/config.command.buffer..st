configuration
config: dbHandle command: commandId buffer: buffer
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_config( db_ptr dbHandle, int commandId, buf_holder buffer) ) module: #unqlite