"
An error for the Jx9 engine

Instance Variables
	source:		<Object>

source
	- the source

"
Class {
	#name : #PqJx9Error,
	#superclass : #PqError,
	#instVars : [
		'source'
	],
	#category : 'PunQLite-Jx9-Exceptions'
}

{ #category : #'instance creation' }
PqJx9Error class >> code: errorCode source: key [
	^(self code: errorCode) source: key
]

{ #category : #testing }
PqJx9Error >> isCompileError [
	^self code = COMPILE_ERR
]

{ #category : #testing }
PqJx9Error >> isVmError [
	^self code = VM_ERR
]

{ #category : #accessing }
PqJx9Error >> kind [
	^#jx9
]

{ #category : #accessing }
PqJx9Error >> source [
	^ source
]

{ #category : #accessing }
PqJx9Error >> source: anObject [
	source := anObject
]
