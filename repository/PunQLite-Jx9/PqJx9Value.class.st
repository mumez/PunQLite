"
A value in the PunQLite Jx9 engine.

Instance Variables
	name:		<String>

name
	- name of the value
"
Class {
	#name : #PqJx9Value,
	#superclass : #PqObject,
	#instVars : [
		'name',
		'executer'
	],
	#category : #'PunQLite-Jx9-Base'
}

{ #category : #'instance creation' }
PqJx9Value class >> named: varName on: rawValueHandle [ 
	^ self new
		name: varName;
		handle: rawValueHandle;
		yourself
]

{ #category : #accessing }
PqJx9Value >> add: aValue [
	| result value |
	
	value := aValue jx9ValueOn: self executer.
	result := self isOk: (self ffi 
		structure: self handle 
		atPosition: ExternalAddress null "Auto assign position"
		putValue: value handle).
	"if value is the same object that came, we let the user to release (It happens if user 
	 sent a PqJx9Value)"
	value == aValue 
		ifFalse: [ self executer release: value ].
	^ result 
]

{ #category : #enumerating }
PqJx9Value >> asArray [ 
	^ Array streamContents: [ :stream | 
		self do: [ :each | stream nextPut: each value ] ]

]

{ #category : #actions }
PqJx9Value >> asBool [
	^(self ffi boolFrom: self handle) = 1.
]

{ #category : #actions }
PqJx9Value >> asBool: aBoolean [
	^self ffi setValue: self handle boolean: (aBoolean ifTrue: [ 1 ] ifFalse: [ 0 ])
]

{ #category : #enumerating }
PqJx9Value >> asDictionary [
	| newDictionary |
	
	newDictionary := PqDictionary new.
	self keysAndValuesDo: [ :key :value | 
		newDictionary at: key asString put: value value ].
	^ newDictionary
]

{ #category : #actions }
PqJx9Value >> asDouble [
	^self ffi doubleFrom: self handle.
]

{ #category : #actions }
PqJx9Value >> asDouble: anObject [
	^self ffi setValue: self handle double: anObject
]

{ #category : #actions }
PqJx9Value >> asInt [
	^self ffi intFrom: self handle.
]

{ #category : #actions }
PqJx9Value >> asInt64 [
	^self ffi int64From: self handle.
]

{ #category : #actions }
PqJx9Value >> asInt64: anObject [
	^self ffi setValue: self handle int64: anObject
]

{ #category : #actions }
PqJx9Value >> asInt: anObject [
	^self ffi setValue: self handle int: anObject
]

{ #category : #actions }
PqJx9Value >> asResource [
	^self ffi resourceFrom: self handle.
]

{ #category : #actions }
PqJx9Value >> asResource: anObject [
	^self ffi setValue: self handle resource: anObject
]

{ #category : #actions }
PqJx9Value >> asString [
	^self ffi stringFrom: self handle.
]

{ #category : #actions }
PqJx9Value >> asString: aString [
	^self ffi setValue: self handle string: aString
]

{ #category : #accessing }
PqJx9Value >> at: aKey put: aValue [
	| value result |
	
	value := aValue jx9ValueOn: self executer.
	result := self ffi structure: self handle atKey: aKey putValue: value handle.
	"if value is the same object that came, we let the user to release (It happens if user 
	 sent a PqJx9Value)"
	value == aValue 
		ifFalse: [ self executer release: value ].
	^ result
	
]

{ #category : #actions }
PqJx9Value >> clear [
	^self ffi clearValue: self handle.
]

{ #category : #enumerating }
PqJx9Value >> do: aBlock [ 
	"if value is JSON array/object, this will work"
	self ffi 
		array: self handle
		walk: (UnQLiteCallback
			signature: #(int (void *pKey, void *pValue, void *pUserData))  
			block: [ :key :value :data | 
				aBlock value: (PqJx9Value named: nil on: value). 
				OK ])
		data: nil	

]

{ #category : #accessing }
PqJx9Value >> elementCount [
	^self ffi structureCount: self handle
]

{ #category : #accessing }
PqJx9Value >> executer [
	^ executer
]

{ #category : #accessing }
PqJx9Value >> executer: anObject [
	executer := anObject
]

{ #category : #accessing }
PqJx9Value >> handle: rawValueHandle [
	handle := rawValueHandle
]

{ #category : #testing }
PqJx9Value >> isBoolean [
	^ (self ffi isBool: self handle) = 1
]

{ #category : #testing }
PqJx9Value >> isFloat [
	^ (self ffi isFloat: self handle) = 1
]

{ #category : #testing }
PqJx9Value >> isInt [
	^ (self ffi isInt: self handle) = 1
]

{ #category : #testing }
PqJx9Value >> isJsonArray [
	^ (self ffi isJsonArray: self handle) = 1
]

{ #category : #testing }
PqJx9Value >> isJsonObject [
	^ (self ffi isJsonObject: self handle) = 1
]

{ #category : #testing }
PqJx9Value >> isNull [
	^ (self ffi isNull: self handle) = 1
]

{ #category : #testing }
PqJx9Value >> isNumeric [
	^ (self ffi isNumeric: self handle) = 1
]

{ #category : #testing }
PqJx9Value >> isResource [
	^ (self ffi isResource: self handle) = 1
]

{ #category : #testing }
PqJx9Value >> isScalar [
	^ (self ffi isScalar: self handle) = 1
]

{ #category : #testing }
PqJx9Value >> isString [
	^ (self ffi isString: self handle) = 1
]

{ #category : #converting }
PqJx9Value >> jx9ValueOn: anExecuter [
	^ self
]

{ #category : #enumerating }
PqJx9Value >> keysAndValuesDo: aBlock [ 
	"if value is JSON array/object, this will work"
	self ffi 
		array: self handle
		walk: (UnQLiteCallback
			signature: #(int (void *pKey, void *pValue, void *pUserData))  
			block: [ :key :value :data | 
				aBlock 
					value: (PqJx9Value named: nil on: key)
					value: (PqJx9Value named: nil on: value). 
				OK ])
		data: nil

]

{ #category : #accessing }
PqJx9Value >> name [
	^ name
]

{ #category : #accessing }
PqJx9Value >> name: anObject [
	name := anObject
]

{ #category : #actions }
PqJx9Value >> resetStringCursor [
	^ self ffi resetStringCursor: self handle
]

{ #category : #converting }
PqJx9Value >> value [ 
	self isString ifTrue: [ ^ self asString ].	
	self isInt ifTrue: [ ^ self asInt ].
	self isBoolean ifTrue: [ ^ self asBool ].
	self isNull ifTrue: [ ^ nil ].
	self isFloat ifTrue: [ ^ self asDouble ].
	self isJsonObject ifTrue: [ ^ self asDictionary ].
	self isJsonArray ifTrue: [ ^ self asArray ].
	self isResource ifTrue: [ ^ self asResource ].
	
	self error: 'unknown data type'
]
