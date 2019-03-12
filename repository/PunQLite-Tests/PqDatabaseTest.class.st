Class {
	#name : #PqDatabaseTest,
	#superclass : #TestCase,
	#instVars : [
		'database'
	],
	#category : 'PunQLite-Tests-Database'
}

{ #category : #accessing }
PqDatabaseTest >> database [
	^ database ifNil: [ database := PqDatabase openOnMemory ]
]

{ #category : #running }
PqDatabaseTest >> setUp [
	
]

{ #category : #running }
PqDatabaseTest >> tearDown [
	database ifNil: [ ^ self ].
	database close
]

{ #category : #testing }
PqDatabaseTest >> testAppendByteArray [
	"self debug: #testAppendByteArray"
	| ok fetched |

	ok := self database appendAt: 'Smalltalk' value: 'COOL' asByteArray.
	self assert: ok.
	
	ok := self database appendAt: 'Smalltalk' value: 'COOL' asByteArray.
	self assert: ok.
	
	fetched := self database fetchAt: 'Smalltalk'.
	self assert: fetched equals: 'COOLCOOL' asByteArray
]

{ #category : #testing }
PqDatabaseTest >> testAppendString [
	"self debug: #testAppendString"
	| ok fetched |
	
	ok := self database appendAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	ok := self database appendAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	fetched := self database fetchStringAt: 'Smalltalk'.
	self assert: fetched equals: 'COOLCOOL'
]

{ #category : #testing }
PqDatabaseTest >> testAppender [
	"self debug: #testAppender"
	| appender ok fetched |

	self deny: (self database includesKey: 'Smalltalk').
	
	appender := self database appenderAt: 'Smalltalk'.
	
	ok := appender 
		nextPutAll: 'COOL'; 
		nextPutAll: 'HOT'; 
		nextPutAll: 'COOL'.
	self assert: ok.
	
	fetched := self database fetchStringAt: 'Smalltalk'.
	self assert: fetched equals: 'COOLHOTCOOL'
]

{ #category : #testing }
PqDatabaseTest >> testAtIfAbsent [
	"self debug: #testAtIfAbsent"
	| fetched |

	self database at: 'Smalltalk' put: 'COOL'.
	
	fetched := self database 
		at: 'Smalltalk' 
		ifAbsent: [:data | fetched := 'Not Found' ].
	self assert: fetched asString equals: 'COOL'.
	
	fetched := nil.
	self database 
		at: 'Pharo' 
		ifAbsent: [ fetched := 'Not Found' ].
	self assert: fetched equals: 'Not Found'
]

{ #category : #testing }
PqDatabaseTest >> testAtIfAbsentPut [
	"self debug: #testAtIfAbsentPut"
	| fetched |

	self database at: 'Smalltalk' put: 'COOL'.
	
	fetched := self database at: 'Smalltalk'.
	self assert: fetched asString equals: 'COOL'.
	
	self database removeKey: 'Smalltalk'.
	self deny: (self database includesKey: 'Smalltalk').
	
	self database at: 'Smalltalk' ifAbsentPut: [ 'cool' asUppercase ].
	fetched := self database at: 'Smalltalk' ifAbsent: [ 'cool??' ].
		
	self assert: fetched asString equals: 'COOL'
]

{ #category : #testing }
PqDatabaseTest >> testAtIfPresent [
	"self debug: #testAtIfPresent"
	| fetched |

	self database at: 'Smalltalk' put: 'COOL'.
	
	self database
		at: 'Smalltalk' 
		ifPresent: [:data | fetched := data asString ].
	self assert: fetched equals: 'COOL'.
	
	fetched := nil.
	self database 
		at: 'Pharo' 
		ifPresent: [:data | fetched := data asString ].
	self assert: fetched isNil
]

{ #category : #testing }
PqDatabaseTest >> testBasicStoreFetchByteArray [
	"self debug: #testBasicStoreFetchByteArray"
	| ok fetched |

	ok := self database storeAt: 'Smalltalk' value: 'COOL' asByteArray.
	self assert: ok.
	
	fetched := self database fetchAt: 'Smalltalk'.
	self assert: fetched equals: 'COOL' asByteArray
]

{ #category : #testing }
PqDatabaseTest >> testBasicStoreFetchString [
	"self debug: #testBasicStoreFetchString"
	| ok fetched |

	ok := self database storeAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	fetched := self database fetchStringAt: 'Smalltalk'.
	self assert: fetched equals: 'COOL'
]

{ #category : #testing }
PqDatabaseTest >> testCursorCurrentDo [
	"self debug: #testCursorCurrentDo"
	| ok cursor entries |
	
	1 to: 10 do: [:index |
		ok := self database 
			storeAt: index asString 
			value: 'value-', index asString.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	cursor seek: '5'.	
	entries := OrderedCollection new.
	cursor fromCurrentDo: [ :theCursor |
		entries add: (theCursor currentStringKey -> theCursor currentStringValue) ].

	self assert: entries size equals: 6.
	self assert: (entries collect: #key) asArray equals: #('5' '6' '7' '8' '9' '10').
	self assert: (entries collect: #value) asArray equals: #('value-5' 'value-6' 'value-7' 'value-8' 'value-9' 'value-10')
]

{ #category : #testing }
PqDatabaseTest >> testCursorCurrentReverseDo [
	"self debug: #testCursorCurrentReverseDo"
	| ok cursor entries |

	1 to: 10 do: [:idx |
		ok := self database 
			storeAt: idx asString 
			value: 'value-', idx asString.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	cursor seek: '5'.
	
	entries := OrderedCollection new.
	cursor fromCurrentReverseDo: [ :theCursor |
		entries add: (theCursor currentStringKey -> theCursor currentStringValue) ].

	self assert: entries size equals: 5.
	self assert: (entries collect: #key) asArray equals: #('5' '4' '3' '2' '1').
	self assert: (entries collect: #value) asArray equals: #('value-5' 'value-4' 'value-3' 'value-2' 'value-1')
]

{ #category : #testing }
PqDatabaseTest >> testCursorDo [
	"self debug: #testCursorDo"
	| ok cursor entries |
	
	1 to: 10 do: [:idx |
		ok := self database 
			storeAt: idx asString 
			value: 'value-', idx asString.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	entries := OrderedCollection new.
	cursor do: [ :theCursor |
		entries add: (theCursor currentStringKey -> theCursor currentStringValue)	].

	self assert: entries size equals: 10.
	self assert: (entries collect: #key) asArray equals: #('1' '2' '3' '4' '5' '6' '7' '8' '9' '10').
	self assert: (entries collect: #value) asArray equals: #('value-1' 'value-2' 'value-3' 'value-4' 'value-5' 'value-6' 'value-7' 'value-8' 'value-9' 'value-10')
]

{ #category : #testing }
PqDatabaseTest >> testCursorFetchByteArray [
	"self debug: #testCursorFetchByteArray"
	| ok cursor |
	
	1 to: 10 do: [ :index |
		ok := self database 
			storeAt: (ByteArray with: index) 
			value: ('value-', index asString) asByteArray.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	cursor first.
	self assert: cursor currentKey equals: #[1].
	self assert: cursor currentValue equals: 'value-1' asByteArray.
	
	cursor next.
	self assert: cursor currentKey equals: #[2].
	self assert: cursor currentValue equals: 'value-2' asByteArray.
	
	cursor last.
	self assert: cursor currentKey equals: #[10].
	self assert: cursor currentValue equals: 'value-10' asByteArray.
	
	cursor previous.
	self assert: cursor currentKey equals: #[9].
	self assert: cursor currentValue equals: 'value-9' asByteArray.
	
	cursor reset.
	self assert: cursor currentKey equals: #[1].
	self assert: cursor currentValue equals: 'value-1' asByteArray.
	
	cursor close.
	self deny: cursor isOpen
]

{ #category : #testing }
PqDatabaseTest >> testCursorFetchByteArrayByCallback [
	"self debug: #testCursorFetchByteArrayByCallback"
	| ok cursor val |

	1 to: 10 do: [ :index |
		ok := self database 
			storeAt: (ByteArray with: index) 
			value: ('value-', index asString) asByteArray.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	cursor first.
	self assert: cursor currentKey equals: #[1].
	cursor currentValueInto: [:data | val := data].
	self assert: val equals: 'value-1' asByteArray.
	
	cursor next.
	self assert: cursor currentKey equals: #[2].
	cursor currentValueInto: [:data | val := data].
	self assert: val equals: 'value-2' asByteArray.
	
	cursor last.
	self assert: cursor currentKey equals: #[10].
	cursor currentValueInto: [:data | val := data].
	self assert: val equals: 'value-10' asByteArray.
	
	cursor close.
	self deny: cursor isOpen
]

{ #category : #testing }
PqDatabaseTest >> testCursorFetchString [
	"self debug: #testCursorFetchString"
	| ok cursor |

	1 to: 10 do: [ :index |
		ok := self database 
			storeAt: index asString 
			value: 'value-', index asString.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	cursor first.
	self assert: cursor currentStringKey equals: '1'.
	self assert: cursor currentStringValue equals: 'value-1'.
	
	cursor next.
	self assert: cursor currentStringKey equals: '2'.
	self assert: cursor currentStringValue equals: 'value-2'.
	
	cursor last.
	self assert: cursor currentStringKey equals: '10'.
	self assert: cursor currentStringValue equals: 'value-10'.
	
	cursor previous.
	self assert: cursor currentStringKey equals: '9'.
	self assert: cursor currentStringValue equals: 'value-9'.
	
	cursor reset.
	self assert: cursor currentStringKey equals: '1'.
	self assert: cursor currentStringValue equals: 'value-1'.
	
	cursor close.
	self assert: cursor isOpen not.
]

{ #category : #testing }
PqDatabaseTest >> testCursorRelease [
	"self debug: #testCursorRelease"
	| ok cursor |

	1 to: 10 do: [:idx |
		ok := self database 
			storeAt: idx asString 
			value: 'value-', idx asString.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	cursor close.
	self deny: cursor isOpen
]

{ #category : #testing }
PqDatabaseTest >> testCursorReverseDo [
	"self debug: #testCursorReverseDo"
	| ok cursor entries |

	1 to: 10 do: [:idx |
		ok := self database 
			storeAt: idx asString 
			value: 'value-', idx asString.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	entries := OrderedCollection new.
	cursor reverseDo: [:cur |
		entries add: (cur currentStringKey -> cur currentStringValue)	].

	self assert: entries size equals: 10.
	self assert: (entries collect: #key) asArray reverse equals: #('1' '2' '3' '4' '5' '6' '7' '8' '9' '10').
	self assert: (entries collect: #value) asArray reverse equals: #('value-1' 'value-2' 'value-3' 'value-4' 'value-5' 'value-6' 'value-7' 'value-8' 'value-9' 'value-10').
	
	cursor close.
	self deny: cursor isOpen
]

{ #category : #testing }
PqDatabaseTest >> testCursorSeek [
	"self debug: #testCursorSeek"
	| ok cursor |

	1 to: 10 do: [:idx |
		ok := self database 
			storeAt: idx asString 
			value: 'value-', idx asString.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	cursor seek: '5'.
	self assert: cursor currentStringValue equals: 'value-5'.

	cursor seek: '10'.
	self assert: cursor currentStringValue equals: 'value-10'.
	
	cursor seek: '3'.
	self assert: cursor currentStringValue equals: 'value-3'.
	
	self deny: (cursor seek: '100').
	
	cursor close.
	self deny: cursor isOpen
]

{ #category : #testing }
PqDatabaseTest >> testCursorSeekUntilBeginDo [
	"self debug: #testCursorSeekUntilBeginDo"
	| ok cursor entries |
	
	1 to: 10 do: [ :index |
		ok := self database 
			storeAt: index asString 
			value: 'value-', index asString.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	entries := OrderedCollection new.
	cursor seek: '5' untilBeginDo: [ :theCursor |
		entries add: (theCursor currentStringKey -> theCursor currentStringValue)	].

	self assert: entries size equals: 5.
	self assert: (entries collect: #key) asArray equals: #('5' '4' '3' '2' '1').
	self assert: (entries collect: #value) asArray equals: #('value-5' 'value-4' 'value-3' 'value-2' 'value-1').
	
	cursor close.
	self deny: cursor isOpen
]

{ #category : #testing }
PqDatabaseTest >> testCursorSeekUntilEndDo [
	"self debug: #testCursorSeekUntilEndDo"
	| ok cursor entries |
	
	1 to: 10 do: [ :index |
		ok := self database 
			storeAt: index asString 
			value: 'value-', index asString.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	entries := OrderedCollection new.
	cursor seek: '5' untilEndDo: [ :theCursor |
		entries add: (theCursor currentStringKey -> theCursor currentStringValue)	].

	self assert: entries size equals: 6.
	self assert: (entries collect: #key) asArray equals: #('5' '6' '7' '8' '9' '10').
	self assert: (entries collect: #value) asArray equals: #('value-5' 'value-6' 'value-7' 'value-8' 'value-9' 'value-10').
	
	cursor close.
	self deny: cursor isOpen
]

{ #category : #testing }
PqDatabaseTest >> testImportFromFile [
	"self debug: #testImportFromFile"
	| fileName  binData imported fetched |

	[binData := #[3 2 1 0 255 254 253 65 64].
	fileName := 'test-', (self database getRandomStringSized: 5).
	
	FileStream 
		forceNewFileNamed: fileName 
		do: [:str | str nextPutAll: binData ].

	self deny: (self database includesKey: fileName).
	
	imported := self database importAt: 'fileData' fromFile: 'not exist file'.	
	self deny: imported.
	
	imported := self database 
		importAt: 'fileData' 
		fromFile: (FileSystem workingDirectory / fileName) pathString.
	self assert: imported.
	
	self database 
		at: 'fileData' 
		ifPresent: [ :data | fetched := data ].
	self assert: fetched equals: binData.
	] ensure: [(FileSystem workingDirectory / fileName) delete]
	
]

{ #category : #testing }
PqDatabaseTest >> testIncludesKey [
	"self debug: #testIncludesKey"
	| ok fetched |

	ok := self database storeAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	ok := self database includesKey: 'Smalltalk'.
	self assert: ok.
	
	ok := self database includesKey: 'Pharo'.
	self assert: ok not.
	
	fetched := self database fetchStringAt: 'Smalltalk'.
	self assert: fetched equals: 'COOL'
]

{ #category : #testing }
PqDatabaseTest >> testKeys [
	"self debug: #testKeys"
	| ok |

	1 to: 10 do: [:index |
		ok := self database 
			storeAt: index asString 
			value: 'value-', index asString.
		self assert: ok ].
	
	self assert: self database size equals: 10.
	self assert: self database keys equals: #('1' '2' '3' '4' '5' '6' '7' '8' '9' '10')

]

{ #category : #testing }
PqDatabaseTest >> testOpenClose [
	"self debug: #testOpenClose"
	| db |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	db close.
	self assert: db isOpen not.
	
]

{ #category : #testing }
PqDatabaseTest >> testRemoveKeyIfAbsent [
	"self debug: #testRemoveKeyIfAbsent"
	| fetched altValue |

	self database at: 'Smalltalk' put: 'COOL'.
	
	fetched := self database at: 'Smalltalk'.
	self assert: fetched asString equals: 'COOL'.
	
	self database removeKey: 'Smalltalk'.
	self deny: (self database includesKey: 'Smalltalk').
	
	altValue := self database removeKey: 'Smalltalk' ifAbsent: ['Pharo'].
	self assert: altValue asString equals: 'Pharo'.
	self deny: (self database includesKey: 'Smalltalk')
]

{ #category : #testing }
PqDatabaseTest >> testStoreDelete [
	"self debug: #testStoreDelete"
	| ok fetched deleted |

	ok := self database storeAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	fetched := self database fetchStringAt: 'Smalltalk'.
	self assert: fetched equals: 'COOL'.
	
	deleted := self database deleteAt: 'Smalltalk'.
	self assert: deleted.
	self 
		should: [ self database fetchStringAt: 'Smalltalk'] 
		raise: PqFetchError.
	
	ok := self database storeAt: 'Pharo' value: 'HOT' asByteArray.
	self assert: ok.
	
	fetched := self database fetchAt: 'Pharo'.
	self assert: fetched equals: 'HOT' asByteArray.
	
	deleted := self database deleteAt: 'Pharo'.
	self assert: deleted.
	self 
		should: [ self database fetchAt: 'Pharo'] 
		raise: PqFetchError
]

{ #category : #testing }
PqDatabaseTest >> testStoreFetchByCallback [
	"self debug: #testStoreFetchByCallback"
	| ok fetched |
	
	ok := self database storeAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	self database 
		fetchAt: 'Smalltalk' 
		basicInto: [ :dataAddr :dataSize :userData |
			| data |
			self assert: dataSize equals: 'COOL' size.
			data := ByteArray new: dataSize.
			LibC memCopy: dataAddr to: data size: dataSize.
			self assert: data asString equals: 'COOL'.
			0 ].
	
	self database 
		fetchAt: 'Smalltalk' 
		into: [:data | fetched := data asString ].
	self assert: fetched equals: 'COOL'
]

{ #category : #testing }
PqDatabaseTest >> testTransactions [
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
]

{ #category : #testing }
PqDatabaseTest >> testTransactionsDisableAutoCommit [
	"self debug: #testTransactionsDisableAutoCommit"
	| dbName db ok fetched |
	
	dbName := 'pq-testTransDisableAutoCommit.db'.
	db := PqDatabase open: (FileSystem workingDirectory / dbName) pathString.
	self assert: db isOpen.
	self assert: db disableAutoCommit.
	
	db beginTransaction.
	ok := db storeAt: 'Smalltalk' value: '???'.
	self assert: ok.
	db commitTransaction.
	
	db beginTransaction.
	ok := db storeAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	db close.
	
	db := PqDatabase open: (FileSystem workingDirectory / dbName) pathString.
	fetched := db fetchStringAt: 'Smalltalk'.
	self assert: fetched equals: '???'.
	
	db beginTransaction.
	ok := db storeAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	db commitTransaction.
	db close.
	
	db := PqDatabase open: (FileSystem workingDirectory / dbName) pathString.
	fetched := db fetchStringAt: 'Smalltalk'.
	self assert: fetched equals: 'COOL'.
	
	db close.
	self assert: db isOpen not.
	(FileSystem workingDirectory / dbName) delete.
	
]

{ #category : #testing }
PqDatabaseTest >> testValues [
	"self debug: #testValues"
	| ok values |

	1 to: 10 do: [:idx |
		ok := self database storeAt: idx asString value: 'value-', idx asString.
		self assert: ok ].
	
	self assert: self database size equals: 10.
	
	values := self database values collect: [:each | each asString].
	self assert: values equals:  #('value-1' 'value-2' 'value-3' 'value-4' 'value-5' 'value-6' 'value-7' 'value-8' 'value-9' 'value-10')
]
