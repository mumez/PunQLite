"
An error while fetching data from PunQLite database

Instance Variables
	key:		<Object>

key
	- the current key

"
Class {
	#name : #PqFetchError,
	#superclass : #PqError,
	#instVars : [
		'key'
	],
	#category : 'PunQLite-DB-Exceptions'
}

{ #category : #'instance creation' }
PqFetchError class >> code: errorCode key: key [
	^(self code: errorCode) key: key
]

{ #category : #testing }
PqFetchError >> isNotFound [
	^self code = NOTFOUND 
]

{ #category : #accessing }
PqFetchError >> key [
	^ key
]

{ #category : #accessing }
PqFetchError >> key: anObject [
	key := anObject
]

{ #category : #accessing }
PqFetchError >> kind [
	^#fetch
]
