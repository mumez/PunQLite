"
I represent a cursor for efficient iteration over key-value pairs in a PunQLite database.

Responsibility:
- Provide sequential and random access to database entries without loading all data
- Support forward and backward iteration through the database
- Enable seeking to specific keys with exact match, greater-than, or less-than semantics
- Allow reading and deletion of entries at the current cursor position
- Implement standard Smalltalk enumeration protocol (do:, reverseDo:)

Collaborators:
- PqDatabase: The database I iterate over, provides handle and settings
- UnQLiteFFI: Makes low-level cursor FFI calls (init, seek, next, prev, release)
- UnQLiteFetchCallback: Used for callback-based data retrieval
- UnQLiteConstants: Provides cursor positioning constants (CURSOR_MATCH_*)

Public API and Key Messages:
- #on: - Create cursor on a database
- #seek: - Position cursor at exact key match
- #seekGreaterThan:, #seekLessThan: - Position cursor relative to key
- #first, #last - Move to first or last entry
- #next, #previous - Move forward or backward one entry
- #do: - Iterate forward from first entry
- #reverseDo: - Iterate backward from last entry
- #seek:untilEndDo: - Seek to key and iterate forward from there
- #currentKey, #currentValue - Read data at current position
- #currentStringKey, #currentStringValue - Read as strings
- #deleteCurrent - Delete entry at current position
- #close - Release cursor resources

Example:
  ""Forward iteration""
  db := PqDatabase openOnMemory.
  db at: 'apple' put: '1'; at: 'banana' put: '2'; at: 'cherry' put: '3'.
  db cursorDo: [:cursor |
    cursor do: [:c |
      Transcript show: c currentStringKey, ' => ', c currentStringValue; cr]].

  ""Seeking and range iteration""
  db cursorDo: [:cursor |
    cursor seek: 'banana' untilEndDo: [:c |
      ""Iterates over 'banana' and 'cherry'""
      Transcript show: c currentStringKey; cr]].

Internal Representation:
- database - The PqDatabase being iterated
- handle - Native unqlite_kv_cursor* pointer (inherited from PqObject)
- handleIsValid - Tracks whether cursor is open

Implementation Points:
- Cursors must be closed after use via #close or #ensure: to prevent leaks
- Cursor state becomes invalid after database modifications (inserts, deletes)
- Always create fresh cursors after modifying the database
- Seeking with CURSOR_MATCH_EXACT returns false if key not found
- CURSOR_MATCH_GE and CURSOR_MATCH_LE provide range query support
- Callback-based retrieval is available via #currentKeyInto: and #currentValueInto:
- Buffer size for key/value retrieval defaults to database's fetchBufferSize
"
Class {
	#name : #PqCursor,
	#superclass : #PqObject,
	#instVars : [
		'database'
	],
	#category : #'PunQLite-DB-Utilities'
}

{ #category : #'instance creation' }
PqCursor class >> on: aDatabase [
	^self new on: aDatabase; yourself
]

{ #category : #'initialize-release' }
PqCursor >> close [
	self isOpen ifFalse: [ ^self ].
	self release
]

{ #category : #testing }
PqCursor >> currentIsValid [
	^(self ffi isValidEntryOn: self handle) ~= 0
]

{ #category : #'accessing key' }
PqCursor >> currentKey [
	^self currentKeySized: self fetchBufferSize
]

{ #category : #'accessing key' }
PqCursor >> currentKey: outKey sized: keySizeHolder [
	^self ffi
		key: outKey
		sized: keySizeHolder
		on: self handle
]

{ #category : #'accessing key' }
PqCursor >> currentKeyBasicInto: aBlock [
	| callback |
	callback := UnQLiteFetchCallback on: aBlock.
	^ self ffi
		keyByCallback: callback
		on: self handle
]

{ #category : #'accessing key' }
PqCursor >> currentKeyByBasicInto: aBlock userData: userData [
	| callback |
	callback := UnQLiteFetchCallback on: aBlock.
	^ self ffi
		keyByCallback: callback
		userData: userData
		on: self handle
]

{ #category : #'accessing key' }
PqCursor >> currentKeyInto: aBlock [
	| wrappedBlock |
	wrappedBlock := [:dataAddr :dataSize :userData | | ret |
		ret := OK.
		[| data |
			data := dataAddr copyFrom: 1 to: dataSize.
			aBlock cull: data cull: userData
		] on: Error do: [:ex | ret := ABORT].
		ret
	].
	^self currentKeyBasicInto: wrappedBlock
]

{ #category : #'accessing key' }
PqCursor >> currentKeySized: keyBufferSize [
	| intHolder bytesAddr ret |
	intHolder := UnQLiteFFI newIntHolder: keyBufferSize.
	bytesAddr := (ExternalAddress gcallocate: keyBufferSize) autoRelease.
	ret := self currentKey: bytesAddr sized: intHolder.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal].
	^bytesAddr copyFrom: 1 to: intHolder value.
]

{ #category : #'accessing key' }
PqCursor >> currentStringKey [
	^self currentStringKeySized: self fetchBufferSize
]

{ #category : #'accessing key' }
PqCursor >> currentStringKeySized: keyBufferSize [
	"Get the current key as a UTF-8 decoded string.

	Important: Uses utf8Decoded for proper multi-byte character handling."
	^(self currentKeySized: keyBufferSize) utf8Decoded

]

{ #category : #'accessig value' }
PqCursor >> currentStringValue [
	^self currentStringValueSized: self fetchBufferSize
]

{ #category : #'accessig value' }
PqCursor >> currentStringValueSized: valueBufferSize [
	"Get the current value as a UTF-8 decoded string.

	Important: Uses utf8Decoded for proper multi-byte character handling."
	^(self currentValueSized: valueBufferSize) utf8Decoded
]

{ #category : #'accessig value' }
PqCursor >> currentValue [
	^self currentValueSized: self fetchBufferSize
]

{ #category : #'accessig value' }
PqCursor >> currentValue: outValue sized: valueSize [
	^self ffi
		value: outValue
		sized: valueSize
		on: self handle
]

{ #category : #'accessig value' }
PqCursor >> currentValueBasicInto: aBlock [
	| callback |

	callback := UnQLiteFetchCallback on: aBlock.
	^ self ffi
		valueByCallback: callback
		on: self handle
]

{ #category : #'accessig value' }
PqCursor >> currentValueBasicInto: aBlock userData: userData [
	| callback |
	callback := UnQLiteFetchCallback on: aBlock.
	^ self ffi
		valueByCallback: callback
		userData: userData
		on: self handle
]

{ #category : #'accessig value' }
PqCursor >> currentValueInto: aBlock [
	| wrappedBlock |

	wrappedBlock := [ :dataAddr :dataSize :userData | | ret |
		ret := OK.
		[ | data |
			data := dataAddr copyFrom: 1 to: dataSize.
			aBlock cull: data cull: userData
		]
		on: Error
		do: [ :ex | ret := ABORT ].
		ret
	].

	^ self currentValueBasicInto: wrappedBlock
]

{ #category : #'accessig value' }
PqCursor >> currentValueInto: aBlock by: aCodec [
	"Fetch the current value, decode it using the specified codec, and pass to aBlock.

	This method uses callback-based retrieval to avoid buffer size limitations.
	"
	| wrappedBlock |

	wrappedBlock := [ :dataAddr :dataSize :userData | | ret |
		ret := OK.
		[ | data decodedData |
			data := dataAddr copyFrom: 1 to: dataSize.
			decodedData := aCodec decode: data.
			aBlock cull: decodedData cull: userData
		]
		on: Error
		do: [ :ex | ret := ABORT ].
		ret
	].

	^ self currentValueBasicInto: wrappedBlock
]

{ #category : #'accessig value' }
PqCursor >> currentValueIntoDecoded: aBlock [
	"Fetch the current value, decode it using the database's default codec, and pass to aBlock.

	This method uses the codec configured on the associated database.
	"

	^ self currentValueInto: aBlock by: self database codec
]

{ #category : #'accessig value' }
PqCursor >> currentValueSized: valueBufferSize [
	| intHolder ourBytes ret |
	intHolder := UnQLiteFFI newIntHolder: valueBufferSize.
	ourBytes := (ExternalAddress gcallocate: valueBufferSize) autoRelease.
	ret := self currentValue: ourBytes sized: intHolder.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal].
	^ourBytes copyFrom: 1 to: intHolder value
]

{ #category : #accessing }
PqCursor >> database [
	^ database
]

{ #category : #accessing }
PqCursor >> database: anObject [
	database := anObject
]

{ #category : #accessing }
PqCursor >> dbHandle [
	^self database handle
]

{ #category : #actions }
PqCursor >> deleteCurrent [
	| ret |
	ret := self ffi deleteEntryOn: self handle.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal]
]

{ #category : #enumeration }
PqCursor >> do: aBlock [
	self first.
	[self currentIsValid] whileTrue: [
		aBlock value: self.
		self next.
	]
]

{ #category : #accessing }
PqCursor >> fetchBufferSize [
	^ fetchBufferSize ifNil: [fetchBufferSize := self database fetchBufferSize]
]

{ #category : #actions }
PqCursor >> first [
	| ret |
	ret := self ffi firstEntryOn: self handle.
	(self isOk: ret) ifFalse: [
		(self isDone: ret) ifFalse: [ (PqCursorError code: ret cursor: self) signal ]]
]

{ #category : #enumeration }
PqCursor >> fromCurrentDo: aBlock [
	[self currentIsValid] whileTrue: [
		aBlock value: self.
		self next.
	]
]

{ #category : #enumeration }
PqCursor >> fromCurrentReverseDo: aBlock [
	[self currentIsValid] whileTrue: [
		aBlock value: self.
		self previous.
	]
]

{ #category : #testing }
PqCursor >> isOkOrDone: returnCode [
	^ (self isOk: returnCode) or: [ returnCode = DONE]
]

{ #category : #testing }
PqCursor >> isOpen [
	^ handle notNil and: [handleIsValid == true]
]

{ #category : #actions }
PqCursor >> last [
	| ret |
	ret := self ffi lastEntryOn: self handle.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal]
]

{ #category : #actions }
PqCursor >> next [
	| ret |
	ret := self ffi nextEntryOn: self handle.
	(self isOkOrDone: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal]
]

{ #category : #'initialize-release' }
PqCursor >> on: aDatabase [
	self database: aDatabase.
	self prepareHandle.
	handleIsValid := self isOk: (self ffi initCursor: self handle db: self dbHandle).
]

{ #category : #actions }
PqCursor >> previous [
	| ret |
	ret := self ffi previousEntryOn: self handle.
	(self isOkOrDone: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal]
]

{ #category : #'initialize-release' }
PqCursor >> release [
	(self isOk: (self ffi releaseCursor: self handle db: self dbHandle ))
		ifTrue: [handleIsValid := false].
	super release.

]

{ #category : #actions }
PqCursor >> reset [
	| ret |
	ret := self ffi resetCursor: self handle.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal]
]

{ #category : #enumeration }
PqCursor >> reverseDo: aBlock [
	self last.
	[self currentIsValid] whileTrue: [
		aBlock value: self.
		self previous.
	]
]

{ #category : #seeking }
PqCursor >> seek: key [
	^ self seek: key by: CURSOR_MATCH_EXACT.
]

{ #category : #seeking }
PqCursor >> seek: key by: seekOption [
	| ret |
	ret := self ffi
		seekKey: (self toByteArray: key)
		sized: key size
		on: self handle by: seekOption.
	(self isOk: ret) ifTrue: [^true].
	(ret = NOTFOUND or: [ret = EOF]) ifTrue: [^false].

	(PqCursorError code: ret cursor: self) signal
]

{ #category : #seeking }
PqCursor >> seek: key untilBeginDo: aBlock [
	(self seek: key) ifTrue: [self fromCurrentReverseDo: aBlock]
]

{ #category : #seeking }
PqCursor >> seek: key untilEndDo: aBlock [
	(self seek: key) ifTrue: [self fromCurrentDo: aBlock]
]

{ #category : #seeking }
PqCursor >> seekGreaterThan: key [
	^ self seek: key by: CURSOR_MATCH_GE.
]

{ #category : #seeking }
PqCursor >> seekLessThan: key [
	^ self seek: key by: CURSOR_MATCH_LE.
]
