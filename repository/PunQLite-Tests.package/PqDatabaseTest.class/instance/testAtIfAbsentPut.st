testing
testAtIfAbsentPut
	"self debug: #testAtIfAbsentPut"
	| db fetched |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	db at: 'Smalltalk' put: 'COOL'.
	
	fetched := db at: 'Smalltalk'.
	self assert: (fetched asString = 'COOL').
	
	db removeKey: 'Smalltalk'.
	self deny: (db includesKey: 'Smalltalk').
	
	db at: 'Smalltalk' ifAbsentPut: ['cool' asUppercase].
	
	fetched := 	db at: 'Smalltalk' ifAbsent: ['cool??'].
		
	self assert: (fetched asString = 'COOL').
	
	db close.
	self assert: db isOpen not.
	