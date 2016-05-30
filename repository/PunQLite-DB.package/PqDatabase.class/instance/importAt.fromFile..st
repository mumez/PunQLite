importing
importAt: key fromFile: filePath
	| fileMap intHolder loaded fileSize  stored |
	fileMap := UnQLiteFFI newStringHolder.
	intHolder := UnQLiteFFI newIntHolder.
	loaded := self ffi 
		loadMmapedFile: fileMap 
		path: filePath 
		sized: intHolder.
	(self isOk: loaded) ifFalse: [^false].
	fileSize := intHolder value.
	stored := self ffi 
		store: self handle 
		key: key 
		sized: key size 
		value: fileMap value 
		sized: fileSize.
	(self isOk: stored) ifFalse: [^false].
	self ffi
		releaseMmapedFile: fileMap value 
		sized: fileSize.
	^true
	