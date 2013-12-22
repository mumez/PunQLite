testing
testBasicStoreFetchString
	"self debug: #testBasicStoreFetchString"
	| db ok fetched |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	ok := db storeAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	fetched := db fetchStringAt: 'Smalltalk'.
	self assert: (fetched = 'COOL').
	
	db close.
	self assert: db isOpen not.
	