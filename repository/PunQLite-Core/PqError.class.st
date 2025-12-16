"
Common superclass for PunQLite errors

Instance Variables
	code:		<Object>
	kind:		<Object>

code
	- xxxxx

kind
	- xxxxx

"
Class {
	#name : 'PqError',
	#superclass : 'Error',
	#instVars : [
		'kind',
		'code'
	],
	#pools : [
		'UnQLiteConstants'
	],
	#category : 'PunQLite-Core-Exceptions',
	#package : 'PunQLite-Core',
	#tag : 'Exceptions'
}

{ #category : 'instance creation' }
PqError class >> code: errorCode [
	^self new code: errorCode; yourself
]

{ #category : 'instance creation' }
PqError class >> kind: aSymbol [
	^self new kind: aSymbol; yourself
]

{ #category : 'accessing' }
PqError >> code [
	^ code
]

{ #category : 'accessing' }
PqError >> code: anErrorCode [
	code := anErrorCode
]

{ #category : 'accessing' }
PqError >> kind [
	^ kind
]

{ #category : 'accessing' }
PqError >> kind: anObject [
	kind := anObject
]
