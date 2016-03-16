utilities
loadMmapedFile: fileMap path: filePath sized: fileSize
	^ self ffiCall: #( int unqlite_util_load_mmaped_file ( String filePath, buf_holder fileMap, bufSize_holder fileSize ) )