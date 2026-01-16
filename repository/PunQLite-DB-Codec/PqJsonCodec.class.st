"
I encode and decode arbitrary objects using JSON serialization.

Responsibility:
- Convert arbitrary Smalltalk objects to JSON-encoded UTF-8 ByteArrays
- Convert JSON-encoded ByteArrays back to Smalltalk objects

Collaborators:
- STONJSON: Used for JSON serialization/deserialization
- PqUtf8Codec: My superclass providing UTF-8 encoding
- PqDatabase: Used when storing complex objects (arrays, dictionaries)

Public API and Key Messages:
- #encode: anObject - Convert object to JSON, then to UTF-8 ByteArray
- #decode: aByteArray - Decode UTF-8 to JSON string, then parse to object

Example:
  codec := PqJsonCodec new.
  encoded := codec encode: #('Alice' 'Bob' 'Charlie').
  decoded := codec decode: encoded.  ""=> #('Alice' 'Bob' 'Charlie')""

  encoded := codec encode: (Dictionary new at: 'name' put: 'Alice'; yourself).
  decoded := codec decode: encoded.  ""=> a Dictionary('name'->'Alice')""
"
Class {
	#name : #PqJsonCodec,
	#superclass : #PqUtf8Codec,
	#category : #'PunQLite-DB-Codec'
}

{ #category : #encoding }
PqJsonCodec >> decode: aByteArray [
	"Decode a JSON-encoded UTF-8 ByteArray to a Smalltalk object"

	^ STONJSON fromString: (super decode: aByteArray)
]

{ #category : #encoding }
PqJsonCodec >> encode: anObject [
	"Encode a Smalltalk object to a JSON-encoded UTF-8 ByteArray"

	^ super encode: (STONJSON toString: anObject)
]
