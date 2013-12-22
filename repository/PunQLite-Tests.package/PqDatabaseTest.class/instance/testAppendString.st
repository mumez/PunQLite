testing
testAppendString
	"self debug: #testAppendString"
	| db ok fetched |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	ok := db appendAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	ok := db appendAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	fetched := db fetchStringAt: 'Smalltalk'.
	self assert: (fetched = 'COOLCOOL').
	
	db close.
	self assert: db isOpen not.
	