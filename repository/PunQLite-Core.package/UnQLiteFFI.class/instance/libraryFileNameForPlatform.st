private
libraryFileNameForPlatform
	| platformClass |
	platformClass := NativeBoost forCurrentPlatform class.
	platformClass = NativeBoostMac32 ifTrue: [^'unqlite.dylib'].
	platformClass = NativeBoostWin32 ifTrue: [^'unqlite.dll'].
	platformClass = NativeBoostLinux32 ifTrue: [^'unqlite.so'].
	^'unqlite'