testing
testBasicStoreFetchByteArray
	"self debug: #testBasicStoreFetchByteArray"
	| db ok fetched |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	ok := db storeAt: 'Smalltalk' value: 'COOL' asByteArray.
	self assert: ok.
	
	fetched := db fetchAt: 'Smalltalk'.
	self assert: (fetched = 'COOL' asByteArray).
	
	db close.
	self assert: db isOpen not.
	