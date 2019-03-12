"
An executor for executing code using the PunQLite Jx9 engine.

Instance Variables
	compiled:		<Object>
	database:		<PqDatabase>
	executed:		<Object>

compiled
	- xxxxx

database
	- the PunQLite database

executed
	- xxxxx

"
Class {
	#name : #PqJx9Executer,
	#superclass : #PqObject,
	#instVars : [
		'database',
		'compiled',
		'executed',
		'callbackCache'
	],
	#category : 'PunQLite-Jx9-Base'
}

{ #category : #'instance creation' }
PqJx9Executer class >> on: aDatabase [
	^self new on: aDatabase; yourself
]

{ #category : #actions }
PqJx9Executer >> @ varName [
	^self extract: varName
]

{ #category : #actions }
PqJx9Executer >> compile: aJx9Source [
	| ret |
	ret := self ffi compile: aJx9Source sized: -1 into: self handle on: self dbHandle.
	(self isOk: ret) 
		ifTrue: [
			handleIsValid := true.
			compiled := true ] 
		ifFalse: [
			(PqJx9Error code: ret source: aJx9Source) signal ].
	^compiled
]

{ #category : #accessing }
PqJx9Executer >> compiled [
	^compiled
]

{ #category : #accessing }
PqJx9Executer >> database [
	^ database
]

{ #category : #accessing }
PqJx9Executer >> database: anObject [
	database := anObject
]

{ #category : #accessing }
PqJx9Executer >> dbHandle [
	^self database handle
]

{ #category : #actions }
PqJx9Executer >> evaluate: aJx9Source [
	self compiled ifFalse: [self compile: aJx9Source].
	^self execute
]

{ #category : #actions }
PqJx9Executer >> execute [
	| ret |
	self compiled ifFalse: [^false].
	self executed ifTrue: [(self reset) ifFalse: [^false]].
	
	ret := self ffi executeOn: self handle.
	(self isOk: ret) ifTrue: [executed := true].
	^executed
]

{ #category : #accessing }
PqJx9Executer >> executed [
	^executed
]

{ #category : #actions }
PqJx9Executer >> extract: varName [
	| rawValueHandle |
	self compiled ifFalse: [^nil].
	self executed ifFalse: [^nil].
	rawValueHandle := self ffi extract: varName on: self handle.
	(rawValueHandle isNil or: [ rawValueHandle isNull]) ifTrue: [^nil].
	^PqJx9Value named: varName on: rawValueHandle 
]

{ #category : #actions }
PqJx9Executer >> inject: aValueObject [

	self compiled ifFalse: [	PqJx9Error signal: 'Script has not been compiled.' ].
	self executed ifTrue: [ PqJx9Error signal: 'Script has been executed.' ].	
	^ self isOk: (self ffi configVM: self handle addVar: aValueObject handle named: aValueObject name) 

]

{ #category : #testing }
PqJx9Executer >> isValid [
	^ handle notNil and: [handleIsValid == true]
]

{ #category : #factory }
PqJx9Executer >> newFunction: aString do: aBlock [
	"installs functions into a jx9 vm. 
	 aBlock will receive a parameter who will be the result of evaluating the record (usually, 
	 this will be a JSON dictionary).
	 aBlock MUST answer a valid Jx9 answer (something that can be answered with unqlite_result_* 
	 functions)"
	| callback |

	callback := FFICallback 
		signature: #(int (void *pCtx, int argc, void **argv)) 
		block:  [ :ctx :argc :argv | | record |
			record := (PqJx9Value named: nil on: (argv pointerAt: 1)) value.
			self 
				result: (aBlock value: record)
				onContext: (PqJx9Context fromHandle: ctx).
			OK ].
	self registerCallback: callback name: aString.
	^ self isOk: (UnQLiteFFI uniqueInstance 
		newFunction: self handle
		name: aString 
		callback: callback thunk
		data: ExternalAddress null).
]

{ #category : #factory }
PqJx9Executer >> newScalar: aName [
	| rawValueHandle |
	rawValueHandle := self ffi newScalar: self handle.
	rawValueHandle ifNil: [ ^nil ].
	^PqJx9Value named: aName on: rawValueHandle
	

]

{ #category : #factory }
PqJx9Executer >> newScalarBoolean: aBoolean [
	^ (self newScalar: nil)
		asBool: aBoolean;
		yourself
]

{ #category : #factory }
PqJx9Executer >> newScalarDouble: aFloat [
	^ (self newScalar: nil)
		asDouble: aFloat;
		yourself
]

{ #category : #factory }
PqJx9Executer >> newScalarInteger64: anInteger [
	^ (self newScalar: nil)
		asInt64: anInteger;
		yourself
]

{ #category : #factory }
PqJx9Executer >> newScalarInteger: anInteger [
	^ (self newScalar: nil)
		asInt: anInteger;
		yourself
]

{ #category : #factory }
PqJx9Executer >> newScalarNull: anUndefinedObject [
	^ (self newScalar: nil)
		clear;
		yourself
]

{ #category : #factory }
PqJx9Executer >> newScalarResource: aByteArray [
	^ (self newScalar: nil)
		asResource: aByteArray;
		yourself
]

{ #category : #factory }
PqJx9Executer >> newScalarString: aString [
	^ (self newScalar: nil)
		"resetStringCursor;"
		asString: aString;
		yourself
]

{ #category : #factory }
PqJx9Executer >> newStructure: aName [
	| rawValueHandle |
	rawValueHandle := self ffi newStructure: self handle.
	rawValueHandle ifNil: [ ^nil ].
	^(PqJx9Value named: aName on: rawValueHandle) executer: self; yourself
	

]

{ #category : #factory }
PqJx9Executer >> newStructure: aString array: aCollection [ 
	| newStructure |
	newStructure := self newStructure: aString.
	aCollection do: [ :each | newStructure add: each ].
	^ newStructure
]

{ #category : #factory }
PqJx9Executer >> newStructure: aString json: aDictionary [ 
	| newStructure |
	newStructure := self newStructure: aString.
	aDictionary keysAndValuesDo: [ :key :value | 
		newStructure at: key put: value ].
	^ newStructure
]

{ #category : #'initailize-release' }
PqJx9Executer >> on: aDatabase [
	self database: aDatabase.
	self prepareHandle.
	
	compiled := false.
	executed := false
	
]

{ #category : #private }
PqJx9Executer >> registerCallback: callback name: aString [
	"I need to keep callbacks in cache because otehrwise they might be collected by GC, 
	 causing a crash. This way, callbacks will remain as long as executor remains."
	callbackCache ifNil: [ callbackCache := Dictionary new ].
	callbackCache at: aString put: callback
]

{ #category : #'initailize-release' }
PqJx9Executer >> release [
	self isValid ifFalse: [ ^self ].
	(self isOk: (self ffi releaseVm: self handle)) 
		ifTrue: [handleIsValid := false].
	super release.
]

{ #category : #actions }
PqJx9Executer >> release: aValueObject [
	^ self isOk: (self ffi releaseValue: aValueObject handle vm: self handle)
]

{ #category : #actions }
PqJx9Executer >> reset [
	| ret |
	ret := self ffi resetExecutionOn: self handle.
	(self isOk: ret) ifFalse: [ ^ false ].
	executed := false.
	^ true
]

{ #category : #actions }
PqJx9Executer >> result: anObject [ 
	^ anObject jx9ResultOn: self
	
]

{ #category : #private }
PqJx9Executer >> result: anObject onContext: aContext [
	^ anObject jx9ResultOn: aContext
	
]
