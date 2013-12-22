configuration
config: dbHandle command: commandId
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_config( db_ptr dbHandle, int commandId) ) module: #unqlite