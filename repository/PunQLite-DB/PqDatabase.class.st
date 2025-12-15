"
A PunQLite database
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
	| ret |
	ret := self ffi 
		append: self handle 
		key: (self toByteArray: key)
		sized: key size 
		value: (self toByteArray: value)
		sized: value size.
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

	^ self 
		deleteAt: key
		sized: key size
]

{ #category : #actions }
PqDatabase >> deleteAt: key sized: keySize [
	| ret |
	
	ret := self ffi 
		delete: self handle 
		key: (self toByteArray: key)
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
	| callback |
	
	callback := UnQLiteFetchCallback on: aBlock.
	^ self ffi 
		fetch: self handle 
		key: (self toByteArray: key)
		sized: key size 
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
	|  intHolder ourBytes ret |

	intHolder := UnQLiteFFI newIntHolder: valueBufSize.
	ourBytes := (ExternalAddress gcallocate: valueBufSize) autoRelease.
	ret := self ffi
		fetch: self handle
		key: (self toByteArray: key)
		sized: key size
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
	| intHolder ourStr ret |
	
	intHolder := UnQLiteFFI newIntHolder: valueBufSize.
	ourStr := (ExternalAddress gcallocate: valueBufSize) autoRelease.
	ret := self ffi 
		fetch: self handle 
		key: (self toByteArray: key)
		sized: key size 
		value: ourStr 
		sized: intHolder.

	(self isOk: ret) ifFalse: [ 
		(PqFetchError code: ret key: key) signal ].

	^ (ourStr copyFrom: 1 to: intHolder value) asString
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
	|  intHolder bytes ret |
	intHolder := UnQLiteFFI newIntHolder: 1.
	bytes := #[0].
	ret := self ffi 
		fetch: self handle 
		key: (self toByteArray: key)
		sized: key size 
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
	| ret |

	ret := self ffi 
		delete: self handle 
		key: (self toByteArray: key)
		sized: key size.
	
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
	| ret |
	
	ret := self ffi 
		store: self handle 
		key: (self toByteArray: key)
		sized: key size 
		value: (self toByteArray: value)
		sized: value size.
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
