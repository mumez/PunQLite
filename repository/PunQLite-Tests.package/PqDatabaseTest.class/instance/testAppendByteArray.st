testing
testAppendByteArray
	"self debug: #testAppendByteArray"
	| db ok fetched |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	ok := db appendAt: 'Smalltalk' value: 'COOL' asByteArray.
	self assert: ok.
	
	ok := db appendAt: 'Smalltalk' value: 'COOL' asByteArray.
	self assert: ok.
	
	fetched := db fetchAt: 'Smalltalk'.
	self assert: (fetched = 'COOLCOOL' asByteArray).
	
	db close.
	self assert: db isOpen not.
	