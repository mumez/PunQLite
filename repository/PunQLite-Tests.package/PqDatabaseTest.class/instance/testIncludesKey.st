testing
testIncludesKey
	"self debug: #testIncludesKey"
	| db ok fetched |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	ok := db storeAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	ok := db includesKey: 'Smalltalk'.
	self assert: ok.
	
	ok := db includesKey: 'Pharo'.
	self assert: ok not.
	
	fetched := db fetchStringAt: 'Smalltalk'.
	self assert: (fetched = 'COOL').
	
	db close.
	self assert: db isOpen not.
	