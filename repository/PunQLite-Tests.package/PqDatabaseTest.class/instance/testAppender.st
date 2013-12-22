testing
testAppender
	"self debug: #testAppender"
	| db appender ok fetched |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	self deny: (db includesKey: 'Smalltalk').
	
	appender := db appenderAt: 'Smalltalk'.
	
	ok := appender nextPutAll: 'COOL'; nextPutAll: 'HOT'; nextPutAll: 'COOL'.
	self assert: ok.
	
	fetched := db fetchStringAt: 'Smalltalk'.
	self assert: (fetched = 'COOLHOTCOOL').
	
	db close.
	self assert: db isOpen not.
	