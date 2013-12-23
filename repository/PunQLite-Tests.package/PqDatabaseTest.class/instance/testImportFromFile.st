testing
testImportFromFile
	"self debug: #testImportFromFile"
	| db fileName  binData imported fetched |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	[binData := #[3 2 1 0 255 254 253 65 64].
	fileName := 'test-', (db getRandomStringSized: 5).
	
	FileStream forceNewFileNamed: fileName do: [:str |
		str nextPutAll: binData
	].

	self deny: (db includesKey: fileName).
	
	imported := db importAt: 'fileData' fromFile: 'not exist file'.	
	self deny: imported.
	
	imported := db importAt: 'fileData' fromFile: (FileSystem workingDirectory / fileName) pathString.
	self assert: imported.
	
	db at: 'fileData' ifPresent: [:data |
		fetched := data.
	].
	self assert: (fetched = binData).
	
	db close.
	self assert: db isOpen not.
	
	] ensure: [(FileSystem workingDirectory / fileName) delete]
	