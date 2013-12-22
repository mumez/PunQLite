testing
testStoreDelete
	"self debug: #testStoreDelete"
	| db ok fetched deleted |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	ok := db storeAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	fetched := db fetchStringAt: 'Smalltalk'.
	self assert: (fetched = 'COOL').
	
	deleted := db deleteAt: 'Smalltalk'.
	self assert: (deleted).
	self should: [ db fetchStringAt: 'Smalltalk'] raise: PqFetchError.
	
	ok := db storeAt: 'Pharo' value: 'HOT' asByteArray.
	self assert: ok.
	
	fetched := db fetchAt: 'Pharo'.
	self assert: (fetched = 'HOT' asByteArray).
	
	deleted := db deleteAt: 'Pharo'.
	self assert: (deleted).
	self should: [ db fetchAt: 'Pharo'] raise: PqFetchError.
	
	db close.
	self assert: db isOpen not.
	