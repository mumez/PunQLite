testing
testImportFromFile
	"self debug: #testImportFromFile"
	| fileName  binData imported fetched |

	[binData := #[3 2 1 0 255 254 253 65 64].
	fileName := 'test-', (self database getRandomStringSized: 5).
	
	FileStream 
		forceNewFileNamed: fileName 
		do: [:str | str nextPutAll: binData ].

	self deny: (self database includesKey: fileName).
	
	imported := self database importAt: 'fileData' fromFile: 'not exist file'.	
	self deny: imported.
	
	imported := self database 
		importAt: 'fileData' 
		fromFile: (FileSystem workingDirectory / fileName) pathString.
	self assert: imported.
	
	self database 
		at: 'fileData' 
		ifPresent: [ :data | fetched := data ].
	self assert: fetched equals: binData.
	] ensure: [(FileSystem workingDirectory / fileName) delete]
	