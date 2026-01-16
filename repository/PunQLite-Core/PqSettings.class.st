"
Settings for UnQLite

Instance Variables
	settingsDict:		<Dictionary>

settingsDict
	- the dictionary with the settings

"
Class {
	#name : 'PqSettings',
	#superclass : 'Object',
	#instVars : [
		'settingsDict'
	],
	#classInstVars : [
		'default'
	],
	#category : 'PunQLite-Core-Settings',
	#package : 'PunQLite-Core',
	#tag : 'Settings'
}

{ #category : 'instance creation' }
PqSettings class >> default [
	^default ifNil: [default := self new].
	
]

{ #category : 'class initialization' }
PqSettings class >> initialize [
	"self initialize"
	self reset
]

{ #category : 'class initialization' }
PqSettings class >> reset [
	<script>
	default := nil
]

{ #category : 'actions-dictionary' }
PqSettings >> at: key [
	^self settingsDict at: key
]

{ #category : 'actions-dictionary' }
PqSettings >> at: key ifAbsent: aBlock [
	^self settingsDict at: key ifAbsent: aBlock
]

{ #category : 'actions-dictionary' }
PqSettings >> at: key ifAbsentPut: aBlock [
	^self settingsDict at: key ifAbsentPut: aBlock
]

{ #category : 'actions-dictionary' }
PqSettings >> at: key put: value [
	^self settingsDict at: key put: value
]

{ #category : 'accessing' }
PqSettings >> defaultCodecClassName [
	"Return the default codec class name for encoding/decoding database values"

	^ self at: #defaultCodecClassName ifAbsentPut: [ #PqUtf8Codec ]
]

{ #category : 'accessing' }
PqSettings >> defaultCodecClassName: aSymbol [
	"Set the default codec class name for encoding/decoding database values"

	^ self at: #defaultCodecClassName put: aSymbol
]

{ #category : 'accessing' }
PqSettings >> defaultFetchBufferSize [
	^self at: #defaultFetchBufferSize ifAbsentPut: [1024]
]

{ #category : 'accessing' }
PqSettings >> defaultFetchBufferSize: anInteger [
	^self at: #defaultFetchBufferSize ifAbsentPut: anInteger
]

{ #category : 'actions-dictionary' }
PqSettings >> includesKey: key [
	^self settingsDict includesKey: key
]

{ #category : 'class initialization' }
PqSettings >> initialize [
	settingsDict := nil
]

{ #category : 'actions-dictionary' }
PqSettings >> keys [
	^self settingsDict keys
]

{ #category : 'printing' }
PqSettings >> printOn: aStream [
	aStream nextPutAll: 'a PqSettings('.
	self settingsDict printOn: aStream.
	aStream nextPutAll: ')'.

]

{ #category : 'accessing-private' }
PqSettings >> settingsDict [
	^ settingsDict ifNil: [settingsDict := IdentityDictionary new]
]
