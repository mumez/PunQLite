configuration
config: dbHandle command: commandId
	^ self ffiCall: #( int unqlite_config( db_ptr dbHandle, int commandId) )