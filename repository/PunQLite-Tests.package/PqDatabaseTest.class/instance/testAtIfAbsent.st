testing
testAtIfAbsent
	"self debug: #testAtIfAbsent"
	| db  fetched |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	db at: 'Smalltalk' put: 'COOL'.
	
	fetched := db at: 'Smalltalk' ifAbsent: [:data |
		fetched := 'Not Found'.
	].
	self assert: (fetched asString = 'COOL').
	
	fetched := nil.
	db at: 'Pharo' ifAbsent: [
		fetched := 'Not Found'.
	].
	self assert: (fetched = 'Not Found').
	
	db close.
	self assert: db isOpen not.
	