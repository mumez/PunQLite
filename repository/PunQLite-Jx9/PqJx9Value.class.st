"
I represent a value in the Jx9 scripting engine, providing bidirectional conversion between Smalltalk and Jx9 types.

Responsibility:
- Wrap native unqlite_value* handles with a Smalltalk object interface
- Provide type checking methods (isInt, isString, isJsonObject, etc.)
- Convert Jx9 values to appropriate Smalltalk types (value method)
- Convert Smalltalk objects to Jx9 values (asInt:, asString:, etc.)
- Support Jx9 structures (arrays and JSON objects) with enumeration protocol
- Manage named variables for injection into Jx9 VM

Collaborators:
- PqJx9Executer: Creates me via newScalar: or newStructure:, manages my lifecycle
- UnQLiteFFI: Makes type checking and conversion FFI calls
- UnQLiteCallback: Used for walking through array/object structures
- PqDictionary: Target type for JSON object conversion via #asDictionary

Public API and Key Messages:
- #named:on: - Create a value wrapper for a native handle
- #value - Convert Jx9 value to appropriate Smalltalk type automatically
- #asInt, #asInt64, #asString, #asBool, #asDouble - Type-specific conversions
- #asArray, #asDictionary - Convert Jx9 structures to Smalltalk collections
- #isInt, #isString, #isBoolean, #isNull, #isFloat - Type checking predicates
- #isJsonObject, #isJsonArray, #isScalar - Structure type checks
- #at:put: - Add key-value pair to Jx9 structure (JSON object)
- #add: - Append element to Jx9 structure (array)
- #do:, #keysAndValuesDo: - Enumerate structure contents
- #name:, #name - Get/set variable name for VM injection

Implementation Points:
- Values are managed by their creating PqJx9Executer
- Always release values via executor's #release: method
- Type conversion via #value uses dynamic dispatch based on Jx9 type
- Structures support both array (indexed) and object (keyed) semantics
- Enumeration callbacks must return OK or ABORT status codes
- String encoding is UTF-8 via FFI marshalling
- Resource values are opaque byte arrays
- JSON compatibility: objects become PqDictionary, arrays become Array
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
