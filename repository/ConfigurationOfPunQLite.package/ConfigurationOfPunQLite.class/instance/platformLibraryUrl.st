doits
platformLibraryUrl
	" Answer a download URL for the compiled version of library "

	Smalltalk os isWin32 
		ifTrue: [ ^ 'https://github.com/mumez/PunQLite/releases/download/v1.1.2/lib-unqlite.dll.zip' ].
	Smalltalk os isUnix 
		ifTrue: [ ^ 'https://github.com/mumez/PunQLite/releases/download/v1.1.2/lib-unqlite.so.zip' ].
	Smalltalk os isMacOSX
		ifTrue: [ ^ 'https://github.com/mumez/PunQLite/releases/download/v1.1.2/lib-unqlite.dylib.zip' ].
	self error: 'Cannot find library for your OS platform'.