"
Common superclass for PunQLite related objects
"
Class {
	#name : 'PqObject',
	#superclass : 'Object',
	#instVars : [
		'handle',
		'handleIsValid',
		'fetchBufferSize',
		'settings'
	],
	#pools : [
		'UnQLiteConstants'
	],
	#category : 'PunQLite-Core-Base',
	#package : 'PunQLite-Core',
	#tag : 'Base'
}

{ #category : 'accessing' }
PqObject >> fetchBufferSize [
	^ fetchBufferSize ifNil: [fetchBufferSize := self settings defaultFetchBufferSize]
]

{ #category : 'accessing' }
PqObject >> fetchBufferSize: anObject [
	fetchBufferSize := anObject
]

{ #category : 'accessing' }
PqObject >> ffi [
	^ UnQLiteFFI uniqueInstance 
]

{ #category : 'initialize-release' }
PqObject >> freeResources [
	(handle isNil or: [ handle isNull ]) 
		ifTrue: [ ^ self ].
	
	[self release]
 	ensure: [
		handle free.
		handle beNull ]
]

{ #category : 'accessing' }
PqObject >> handle [
	^ handle
]

{ #category : 'initialize-release' }
PqObject >> initialize [
	super initialize.
	handleIsValid := false.

]

{ #category : 'testing' }
PqObject >> isDone: returnCode [
	^ returnCode = DONE
]

{ #category : 'testing' }
PqObject >> isOk: returnCode [
	^ returnCode = OK
]

{ #category : 'initialize-release' }
PqObject >> prepareHandle [
	^ handle ifNil: [ handle := ExternalAddress new ]
]

{ #category : 'initialize-release' }
PqObject >> release [
	
]

{ #category : 'accessing' }
PqObject >> settings [
	^ settings ifNil: [settings := PqSettings default]
]

{ #category : 'accessing' }
PqObject >> settings: aPqSettings [
	settings := aPqSettings
]

{ #category : 'private' }
PqObject >> toByteArray: anObject [

	^ anObject isString 
		ifTrue: [ anObject utf8Encoded ]
		ifFalse: [ anObject ]
]
