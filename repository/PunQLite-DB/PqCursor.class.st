"
A cursor over a PunQLite database

Instance Variables
	database:		<PqDatabase>

database
	- the PunQLite database to use

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
			data := ByteArray new: dataSize.
			LibC memCopy: dataAddr to: data size: dataSize.
			aBlock cull: data cull: userData
		] on: Error do: [:ex | ret := ABORT]. 
		ret
	].
	^self currentKeyBasicInto: wrappedBlock
]

{ #category : #'accessing key' }
PqCursor >> currentKeySized: keyBufferSize [
	| intHolder bytes ret |
	intHolder := UnQLiteFFI newIntHolder: keyBufferSize.
	bytes := ByteArray new: keyBufferSize.
	ret := self currentKey: bytes sized: intHolder.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal].
	^bytes copyFrom: 1 to: intHolder value.
]

{ #category : #'accessing key' }
PqCursor >> currentStringKey [
	^self currentStringKeySized: self fetchBufferSize
]

{ #category : #'accessing key' }
PqCursor >> currentStringKeySized: keyBufferSize [
	| ourStr intHolder ret |
	intHolder := UnQLiteFFI newIntHolder: keyBufferSize.
	ourStr := ByteArray new: keyBufferSize.
	ret := self currentKey: ourStr sized: intHolder.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal].
	^ourStr readString.

]

{ #category : #'accessig value' }
PqCursor >> currentStringValue [
	^self currentStringValueSized: self fetchBufferSize
]

{ #category : #'accessig value' }
PqCursor >> currentStringValueSized: valueBufferSize [
	| intHolder ourStr ret |
	intHolder := UnQLiteFFI newIntHolder: valueBufferSize.
	ourStr := ByteArray new: valueBufferSize.
	ret := self currentValue: ourStr sized: intHolder.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal].
	^ourStr readString
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
			data := ByteArray new: dataSize.
			LibC memCopy: dataAddr to: data size: dataSize.
			aBlock cull: data cull: userData
		] 
		on: Error 
		do: [ :ex | ret := ABORT ]. 
		ret
	].

	^ self currentValueBasicInto: wrappedBlock
]

{ #category : #'accessig value' }
PqCursor >> currentValueSized: valueBufferSize [
	| intHolder bytes ret |
	intHolder := UnQLiteFFI newIntHolder: valueBufferSize.
	bytes := ByteArray new: valueBufferSize.
	ret := self currentValue: bytes sized: intHolder.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal].
	^bytes copyFrom: 1 to: intHolder value
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
