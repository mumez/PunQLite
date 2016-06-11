doits
preLoad
	| url fileRef response |

	self platformLibraryName asFileReference exists 
		ifTrue: [ ^ self ].

	url := self platformLibraryUrl asZnUrl.
	fileRef := FileSystem disk workingDirectory / url pathSegments last.
	(response := ZnEasy get: url) isSuccess
		ifTrue: [ fileRef writeStreamDo: [ : stream | stream nextPutAll: response contents ] ]
		ifFalse: [ self error: 'Cannot download compiled library file' ].
	self uncompress: fileRef.