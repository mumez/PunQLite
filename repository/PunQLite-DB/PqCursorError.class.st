"
A PunQLite cursor error

Instance Variables
	cursor:		<PqCursor>

cursor
	- the cursor

"
Class {
	#name : #PqCursorError,
	#superclass : #PqError,
	#instVars : [
		'cursor'
	],
	#category : 'PunQLite-DB-Exceptions'
}

{ #category : #'instance creation' }
PqCursorError class >> code: errorCode cursor: aCursor [
	^(self code: errorCode) cursor: aCursor
]

{ #category : #accessing }
PqCursorError >> cursor [
	^ cursor
]

{ #category : #accessing }
PqCursorError >> cursor: anObject [
	cursor := anObject
]
