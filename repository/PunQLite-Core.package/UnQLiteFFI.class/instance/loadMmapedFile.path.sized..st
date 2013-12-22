utilities
loadMmapedFile: fileMap path: filePath sized: fileSize
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_util_load_mmaped_file(String filePath, void** fileMap, int64_t* fileSize) ) module: #unqlite