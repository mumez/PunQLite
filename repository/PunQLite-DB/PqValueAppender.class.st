"
Utility object to append values

Instance Variables
	database:		<PqDatabase>
	key:				<Object>

database
	- database to append values to

key
	- key to append to

"
Class {
	#name : #PqValueAppender,
	#superclass : #Object,
	#instVars : [
		'database',
		'key'
	],
	#category : 'PunQLite-DB-Utilities'
}

{ #category : #'instance creation' }
PqValueAppender class >> key: appendKey on: aDatabase [
	^self new key: appendKey; database: aDatabase; yourself
]

{ #category : #accessing }
PqValueAppender >> database [
	^ database
]

{ #category : #accessing }
PqValueAppender >> database: anObject [
	database := anObject
]

{ #category : #accessing }
PqValueAppender >> key [
	^ key
]

{ #category : #accessing }
PqValueAppender >> key: anObject [
	key := anObject
]

{ #category : #actions }
PqValueAppender >> nextPutAll: data [
	^ self database appendAt: self key value: data
]
