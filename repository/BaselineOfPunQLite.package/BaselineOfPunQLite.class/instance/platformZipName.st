accessing
platformZipName
	" Answer a name for the compiled version of the library "

	Smalltalk os isWin32 
		ifTrue: [ ^ 'lib-unqlite.dll.zip' ].
	Smalltalk os isUnix 
		ifTrue: [ ^ 'lib-unqlite.so.zip' ].
	Smalltalk os isMacOSX
		ifTrue: [ ^ 'lib-unqlite.dylib.zip' ].
	
	self error: 'Unsupported OS platform'.