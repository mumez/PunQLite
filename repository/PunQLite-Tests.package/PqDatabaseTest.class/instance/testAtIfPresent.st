testing
testAtIfPresent
	"self debug: #testAtIfPresent"
	| db  fetched |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	db at: 'Smalltalk' put: 'COOL'.
	
	db at: 'Smalltalk' ifPresent: [:data |
		fetched := data asString.
	].
	self assert: (fetched = 'COOL').
	
	fetched := nil.
	db at: 'Pharo' ifPresent: [:data |
		fetched := data asString.
	].
	self assert: (fetched isNil).
	
	db close.
	self assert: db isOpen not.
	