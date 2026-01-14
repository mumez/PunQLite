"
I represent a PunQLite database connection providing a Dictionary-like interface to UnQLite's key-value store.

Responsibility:
- Provide high-level Dictionary API for key-value storage (at:, at:put:, keys, values, do:)
- Manage database lifecycle (open, close, transaction handling)
- Support both file-based and in-memory databases
- Create and manage cursors for efficient iteration
- Provide access to Jx9 scripting engine and JSON document collections
- Handle data marshalling between Smalltalk objects and byte arrays

Collaborators:
- UnQLiteFFI: Makes low-level FFI calls for all database operations
- PqCursor: Created via #newCursor for efficient database iteration
- PqCollection: Created via #collectionName: for JSON document storage
- PqJx9Executer: Created via #jx9 for Jx9 script execution
- PqValueAppender: Created via #appenderAt: for efficient value appending
- UnQLiteConstants: Provides mode constants and return codes

Public API and Key Messages:
- #openOnMemory - Create in-memory database (for testing or temporary storage)
- #open:mode: - Open file-based database with specified mode flags
- #at:put: - Store a value at a key (like Dictionary)
- #at: - Fetch a value by key (raises PqFetchError if not found)
- #at:ifAbsent: - Fetch with default value on missing key
- #removeKey: - Delete a key-value pair
- #keys, #values, #do: - Collection protocol for iteration
- #newCursor - Create a cursor for efficient scanning
- #transact: - Execute a block within a manual transaction
- #close - Close database and release native resources

Example:
  ""Basic key-value operations""
  db := PqDatabase openOnMemory.
  db at: 'user:1' put: 'Alice'.
  db at: 'user:2' put: 'Bob'.
  db at: 'user:1'.  ""=> 'Alice'""
  db keys.  ""=> #('user:1' 'user:2')""
  db close.

  ""Using cursor for efficient iteration""
  db := PqDatabase openOnMemory.
  db at: 'a' put: '1'; at: 'b' put: '2'.
  db cursorDo: [:cursor |
    cursor do: [:c | Transcript show: c currentStringKey, ' => ', c currentStringValue; cr]].

Internal Representation:
- Inherits handle from PqObject - points to unqlite* database handle
- handleIsValid - tracks whether database is open

Implementation Points:
- Keys and values are stored as byte arrays (UTF-8 for strings)
- Default mode is OPEN_CREATE (create if not exists, read-write)
- In-memory databases use ':mem:' as the file path
- Transaction modes: auto-commit (default) or manual via #disableAutoCommit
- Always call #close to release native resources (use #ensure: in production)
- Cursors become invalid after database modifications
- Fetch operations may need larger buffer sizes for large values (see #fetchBufferSize:)
"
Class {
	#name : #PqDatabase,
	#superclass : #PqObject,
	#category : #'PunQLite-DB-Base'
}

{ #category : #opening }
PqDatabase class >> open: filePath [
	^self open: filePath mode: OPEN_CREATE.
]

{ #category : #opening }
PqDatabase class >> open: filePath mode: mode [
	^ self new open: filePath mode: mode
]

{ #category : #opening }
PqDatabase class >> openOnMemory [
	^self open: ':mem:' mode: OPEN_IN_MEMORY.
]

{ #category : #actions }
PqDatabase >> appendAt: key value: value [
	"Append a value to an existing key. Automatically converts strings to UTF-8.

	Important: Uses the correct byte size after UTF-8 encoding, not character count.
	"
	| ret keyBytes valueBytes |

	keyBytes := self toByteArray: key.
	valueBytes := self toByteArray: value.
	ret := self ffi
		append: self handle
		key: keyBytes
		sized: keyBytes size
		value: valueBytes
		sized: valueBytes size.
	^self isOk: ret
]

{ #category : #'actions-appender' }
PqDatabase >> appenderAt: key [

	^ PqValueAppender key: key on: self
]

{ #category : #'actions-dictionary' }
PqDatabase >> at: key [
	^ self fetchAt: key.
]

{ #category : #'actions-dictionary' }
PqDatabase >> at: key ifAbsent: aBlock [
	^ [ self fetchAt: key ]
		on: PqFetchError
		do: [ :ex |
			ex isNotFound
				ifTrue: [ aBlock value ]
				ifFalse: [ ex pass ] ]
]

{ #category : #'actions-dictionary' }
PqDatabase >> at: key ifAbsentPut: aBlock [
	^ [ self fetchAt: key ]
		on: PqFetchError
		do: [ :ex |
			ex isNotFound
				ifTrue: [ self at: key put: aBlock value ]
				ifFalse: [ ex pass ] ]
]

{ #category : #'actions-dictionary' }
PqDatabase >> at: key ifPresent: aBlock [
	self fetchAt: key into: aBlock.
	^ key
]

{ #category : #'actions-dictionary' }
PqDatabase >> at: key put: value [
	self storeAt: key value: value.
	^value
]

{ #category : #transactions }
PqDatabase >> beginTransaction [
	| ret |
	ret := self ffi beginTransactionOn: self handle.
	^self isOk: ret
]

{ #category : #closing }
PqDatabase >> close [
	self isOpen ifFalse: [ ^self ].
	(self isOk: (self ffi close: self handle))
		ifTrue: [handleIsValid := false]
]

{ #category : #accessing }
PqDatabase >> collectionName: aString [
	^ PqCollection database: self name: aString
]

{ #category : #transactions }
PqDatabase >> commitTransaction [
	| ret |
	ret := self ffi commitTransactionOn: self handle.
	^self isOk: ret
]

{ #category : #'actions-cursor' }
PqDatabase >> cursorDo: aBlock [
	| cur |
	[cur := self newCursor.
	aBlock value: cur.
	] ensure: [cur ifNotNil: [cur close]]
]

{ #category : #actions }
PqDatabase >> deleteAt: key [
	"Delete a key-value pair by key.

	Important: Computes correct byte size after UTF-8 encoding.
	"
	| keyBytes |

	keyBytes := self toByteArray: key.
	^ self
		deleteAt: key
		sized: keyBytes size
]

{ #category : #actions }
PqDatabase >> deleteAt: key sized: keySize [
	"Delete a key-value pair by key with explicit key size.

	Important: keySize should be the byte size, not character count.
	"
	| ret keyBytes |

	keyBytes := self toByteArray: key.
	ret := self ffi
		delete: self handle
		key: keyBytes
		sized: keySize.
	^ self isOk: ret
]

{ #category : #configuration }
PqDatabase >> disableAutoCommit [
	| ret |
	ret := self ffi
		config: self handle
		command: CONFIG_DISABLE_AUTO_COMMIT.
	^self isOk: ret
]

{ #category : #'actions-dictionary' }
PqDatabase >> do: aBlock [
	self cursorDo: [:cur | cur do: aBlock]
]

{ #category : #actions }
PqDatabase >> fetchAt: key [

	^ self
		fetchAt: key
		sized: self fetchBufferSize
]

{ #category : #actions }
PqDatabase >> fetchAt: key basicInto: aBlock [
	"Fetch a value by key using a callback for custom processing.

	Important: Uses the correct byte size after UTF-8 encoding for the key.
	"
	| callback keyBytes |

	keyBytes := self toByteArray: key.
	callback := UnQLiteFetchCallback on: aBlock.
	^ self ffi
		fetch: self handle
		key: keyBytes
		sized: keyBytes size
		callback: callback
]

{ #category : #actions }
PqDatabase >> fetchAt: key into: aBlock [
	| wrappedBlock |

	wrappedBlock := [ :dataAddr :dataSize :userData | | ret |
		ret := OK.
		[ | data |
			data := dataAddr copyFrom: 1 to: dataSize.
			aBlock cull: data cull: userData ]
		on: Error
		do: [ :ex | ret := ABORT ].
		ret ].

	^ self fetchAt: key basicInto: wrappedBlock
]

{ #category : #actions }
PqDatabase >> fetchAt: key sized: valueBufSize [
	"Fetch a value by key as a byte array.

	Important: Uses the correct byte size after UTF-8 encoding for the key.
	"
	|  intHolder ourBytes ret keyBytes |

	keyBytes := self toByteArray: key.
	intHolder := UnQLiteFFI newIntHolder: valueBufSize.
	ourBytes := (ExternalAddress gcallocate: valueBufSize) autoRelease.
	ret := self ffi
		fetch: self handle
		key: keyBytes
		sized: keyBytes size
		value: ourBytes
		sized: intHolder.
	(self isOk: ret) ifFalse: [
		(PqFetchError code: ret key: key) signal ].

	^ ourBytes copyFrom: 1 to: intHolder value
]

{ #category : #actions }
PqDatabase >> fetchStringAt: key [

	^ self
		fetchStringAt: key
		sized: self fetchBufferSize
]

{ #category : #actions }
PqDatabase >> fetchStringAt: key sized: valueBufSize [
	"Fetch a string value by key with automatic UTF-8 decoding.

	Important: Uses the correct byte size after UTF-8 encoding for the key.
	"
	| intHolder ourStr ret keyBytes |

	keyBytes := self toByteArray: key.
	intHolder := UnQLiteFFI newIntHolder: valueBufSize.
	ourStr := (ExternalAddress gcallocate: valueBufSize) autoRelease.
	ret := self ffi
		fetch: self handle
		key: keyBytes
		sized: keyBytes size
		value: ourStr
		sized: intHolder.

	(self isOk: ret) ifFalse: [
		(PqFetchError code: ret key: key) signal ].

	^ (ourStr copyFrom: 1 to: intHolder value) utf8Decoded
]

{ #category : #'system-info' }
PqDatabase >> getErrorLog [
	|  strOut intOut |
	strOut := UnQLiteFFI newStringHolder.
	intOut := UnQLiteFFI newIntHolder.
	self ffi
		config: self handle
		command: CONFIG_ERR_LOG
		buffer: strOut
		sized: intOut.
	^strOut value
]

{ #category : #'system-info' }
PqDatabase >> getKeyValueStoreName [
	|  strOut |
	strOut := UnQLiteFFI newStringHolder.
	self ffi
		config: self handle
		command: CONFIG_GET_KV_NAME
		buffer: strOut.
	^strOut value
]

{ #category : #utilities }
PqDatabase >> getRandomNumber [
	^self ffi getRandomNumber: self handle
]

{ #category : #utilities }
PqDatabase >> getRandomStringSized: size [
	| ourStr |
	ourStr := (ExternalAddress gcallocate: size) autoRelease.
	self ffi getRandomString: self handle into: ourStr sized: size.
	^ (ourStr copyFrom: 1 to: size) asString
]

{ #category : #importing }
PqDatabase >> importAt: key fromFile: filePath [
	| fileMap intHolder loaded fileSize  stored |
	fileMap := UnQLiteFFI newStringHolder.
	intHolder := UnQLiteFFI newIntHolder.
	loaded := self ffi
		loadMmapedFile: fileMap
		path: filePath
		sized: intHolder.
	(self isOk: loaded) ifFalse: [^false].
	fileSize := intHolder value.
	stored := self ffi
		store: self handle
		key: (self toByteArray: key)
		sized: key size
		value: fileMap value
		sized: fileSize.
	(self isOk: stored) ifFalse: [^false].
	self ffi
		releaseMmapedFile: fileMap value
		sized: fileSize.
	^true

]

{ #category : #'actions-dictionary' }
PqDatabase >> includesKey: key [
	"Check if a key exists in the database.

	Important: Uses the correct byte size after UTF-8 encoding for the key.
	"
	|  intHolder bytes ret keyBytes |

	keyBytes := self toByteArray: key.
	intHolder := UnQLiteFFI newIntHolder: 1.
	bytes := #[0].
	ret := self ffi
		fetch: self handle
		key: keyBytes
		sized: keyBytes size
		value: bytes
		sized: intHolder.
	^self isOk: ret
]

{ #category : #testing }
PqDatabase >> isOpen [
	^ handle notNil and: [handleIsValid == true]
]

{ #category : #'actions-dictionary' }
PqDatabase >> keys [
	| keys |
	keys := OrderedCollection new.
	self do: [:cursor |
		keys add: (cursor currentStringKey)
	].
	^keys asArray
]

{ #category : #'actions-cursor' }
PqDatabase >> newCursor [
	^PqCursor on: self
]

{ #category : #'actions-cursor' }
PqDatabase >> newCursorAt: seekKey [
	| cursor |
	cursor := self newCursor.
	(cursor seek: seekKey) ifTrue: [^cursor].
	^nil
]

{ #category : #opening }
PqDatabase >> open: filePath mode: mode [
	self isOpen ifTrue: [ ^self ].
	handleIsValid := self isOk: (self ffi
		open: self prepareHandle
		named: filePath
		mode: mode)
]

{ #category : #'actions-dictionary' }
PqDatabase >> removeKey: key [
	"Remove a key-value pair from the database.

	Important: Uses the correct byte size after UTF-8 encoding for the key.
	"
	| ret keyBytes |

	keyBytes := self toByteArray: key.
	ret := self ffi
		delete: self handle
		key: keyBytes
		sized: keyBytes size.

	(self isOk: ret) ifFalse: [
		(PqUpdateError code: ret key: key) signal ].

	^ key

]

{ #category : #'actions-dictionary' }
PqDatabase >> removeKey: key ifAbsent: aBlock [
	^ [ self removeKey: key]
		on: PqUpdateError
		do: [ :ex |
			ex isNotFound
				ifTrue: [aBlock value ]
				ifFalse: [ ex pass ] ]
]

{ #category : #'actions-dictionary' }
PqDatabase >> reverseDo: aBlock [
	self cursorDo: [:cur | cur reverseDo: aBlock]
]

{ #category : #transactions }
PqDatabase >> rollbackTransaction [
	| ret |
	ret := self ffi rollbackTransactionOn: self handle.
	^self isOk: ret
]

{ #category : #'actions-dictionary' }
PqDatabase >> size [
	| size |
	size := 0.
	self do: [:cur | size := size + 1].
	^size
]

{ #category : #actions }
PqDatabase >> storeAt: key value: value [
	"Store a value at the given key. Automatically converts strings to UTF-8.

	Important: Uses the correct byte size after UTF-8 encoding, not character count.
	This fixes multi-byte character handling (e.g., Japanese, Chinese, emoji).
	"
	| ret keyBytes valueBytes |

	keyBytes := self toByteArray: key.
	valueBytes := self toByteArray: value.
	ret := self ffi
		store: self handle
		key: keyBytes
		sized: keyBytes size
		value: valueBytes
		sized: valueBytes size.
	^ self isOk: ret
]

{ #category : #transactions }
PqDatabase >> transact: aBlock [
	self beginTransaction.
	aBlock ensure: [
		(self commitTransaction) ifFalse: [
			self rollbackTransaction.
			PqError signal: 'Could not commit.' ] ].
]

{ #category : #'actions-dictionary' }
PqDatabase >> values [
	| values |
	values := OrderedCollection new.
	self do: [:cursor |
		values add: (cursor currentValue)
	].
	^values asArray
]
