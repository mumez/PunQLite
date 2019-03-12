"
I'm a UnQLite context (unqlite_ context).
I'm used whenever Jx9 creates a context (typically, a function).
"
Class {
	#name : #PqJx9Context,
	#superclass : #PqObject,
	#category : 'PunQLite-Jx9-Base'
}

{ #category : #'instance creation' }
PqJx9Context class >> fromHandle: aHandle [
	^ self basicNew 
		initializeHandle: aHandle;
		yourself
]

{ #category : #'instance creation' }
PqJx9Context class >> new [
	self error: 'Use #fromHandle:'
]

{ #category : #initialization }
PqJx9Context >> initializeHandle: aHandle [
	handle := aHandle.
	self initialize.
	
]

{ #category : #factory }
PqJx9Context >> newResultBoolean: aBoolean [
	^ self ffi result: self handle boolean: aBoolean
]

{ #category : #factory }
PqJx9Context >> newResultDouble: aFloat [
	^ self ffi result: self handle double: aFloat
]

{ #category : #factory }
PqJx9Context >> newResultInteger64: anInteger [
	^ self ffi result: self handle int64: anInteger
]

{ #category : #factory }
PqJx9Context >> newResultInteger: anInteger [
	^ self ffi result: self handle int: anInteger
]

{ #category : #factory }
PqJx9Context >> newResultNull [
	^ self ffi resultNull: self handle
]

{ #category : #factory }
PqJx9Context >> newResultResource: aByteArray [
	^ self ffi result: self handle resource: aByteArray
]

{ #category : #factory }
PqJx9Context >> newResultString: aString [
	^ self ffi result: self handle string: aString
]
