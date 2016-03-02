configuration
config: dbHandle command: commandId buffer: buffer
	^ self ffiCall: #( int unqlite_config( db_ptr dbHandle, int commandId, buf_holder buffer) )