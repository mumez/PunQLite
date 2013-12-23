testing
testTransactions
	"self debug: #testTransactions"
	| dbName db ok fetched |
	dbName := 'pq-testTransactions.db'.
	db := PqDatabase open: (FileSystem workingDirectory / dbName) pathString.
	self assert: db isOpen.
	
	db beginTransaction.
	ok := db storeAt: 'Smalltalk' value: '???'.
	self assert: ok.
	db commitTransaction.
	
	db beginTransaction.
	ok := db storeAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	db rollbackTransaction.
	
	fetched := db fetchStringAt: 'Smalltalk'.
	self assert: (fetched = '???').
	
	db beginTransaction.
	ok := db storeAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	db commitTransaction.
	
	fetched := db fetchStringAt: 'Smalltalk'.
	self assert: (fetched = 'COOL').
	
	db close.
	self assert: db isOpen not.
	(FileSystem workingDirectory / dbName) delete.