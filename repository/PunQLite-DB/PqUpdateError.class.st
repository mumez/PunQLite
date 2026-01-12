"
An error thrown while updating PunQLite database

Instance Variables
	key:		<Object>

key
	- the current key

"
Class {
	#name : #PqUpdateError,
	#superclass : #PqError,
	#instVars : [
		'key'
	],
	#category : 'PunQLite-DB-Exceptions'
}

{ #category : #'instance creation' }
PqUpdateError class >> code: errorCode key: key [
	^(self code: errorCode) key: key
]

{ #category : #testing }
PqUpdateError >> isNotFound [
	^self code = NOTFOUND
]

{ #category : #accessing }
PqUpdateError >> key [
	^ key
]

{ #category : #accessing }
PqUpdateError >> key: anObject [
	key := anObject
]

{ #category : #accessing }
PqUpdateError >> kind [
	^#update
]
