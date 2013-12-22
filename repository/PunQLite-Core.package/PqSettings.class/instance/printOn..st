printing
printOn: aStream
	aStream nextPutAll: 'a PqSettings('.
	self settingsDict printOn: aStream.
	aStream nextPutAll: ')'.
