testing
testRemoveKeyIfAbsent
	"self debug: #testRemoveKeyIfAbsent"
	| db fetched altValue |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	db at: 'Smalltalk' put: 'COOL'.
	
	fetched := db at: 'Smalltalk'.
	self assert: (fetched asString = 'COOL').
	
	db removeKey: 'Smalltalk'.
	self deny: (db includesKey: 'Smalltalk').
	
	altValue := db removeKey: 'Smalltalk' ifAbsent: ['Pharo'].
	self assert: (altValue asString = 'Pharo').
	self deny: (db includesKey: 'Smalltalk').
	
	db close.
	self assert: db isOpen not
	