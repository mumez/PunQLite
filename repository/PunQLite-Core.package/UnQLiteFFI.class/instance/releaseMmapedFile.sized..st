utilities
releaseMmapedFile: fileMap sized: fileSize
	^ self ffiCall: #( int unqlite_util_release_mmaped_file( void* fileMap, int64_t fileSize) )