importing
importAt: key fromFile: filePath
	| fileMap intHolder loaded fileSize  stored |
	fileMap := UnQLiteFFI newStringHolder.
	intHolder := UnQLiteFFI newIntHolder.
	loaded := ffi loadMmapedFile: fileMap path: filePath sized: intHolder.
	(self isOk: loaded) ifFalse: [^false].
	fileSize := intHolder value.
	stored := ffi store: self handle key: key sized: key size value: fileMap value sized: fileSize.
	(self isOk: stored) ifFalse: [^false].
	ffi releaseMmapedFile: fileMap value sized: fileSize.
	^true
	