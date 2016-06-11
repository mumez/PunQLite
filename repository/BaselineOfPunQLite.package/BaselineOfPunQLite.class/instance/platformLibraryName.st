accessing
platformLibraryName
	" Answer a name for the compiled version of the library "

	Smalltalk os isWin32 
		ifTrue: [ ^ 'unqlite.dll' ].
	Smalltalk os isUnix 
		ifTrue: [ ^ 'unqlite.so' ].
	Smalltalk os isMacOSX
		ifTrue: [ ^ 'unqlite.dylib' ].
	
	self error: 'Unsupported OS platform'