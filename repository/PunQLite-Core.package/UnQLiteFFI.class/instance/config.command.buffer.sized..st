configuration
config: dbHandle command: commandId buffer: buffer sized: bufferSize
	^ self ffiCall: #( int unqlite_config( db_ptr dbHandle, int commandId, buf_holder buffer, int* bufferSize) )