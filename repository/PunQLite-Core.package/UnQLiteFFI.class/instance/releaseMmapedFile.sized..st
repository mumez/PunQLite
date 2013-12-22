utilities
releaseMmapedFile: fileMap sized: fileSize
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_util_release_mmaped_file( void* fileMap, int64_t fileSize) ) module: #unqlite