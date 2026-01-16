"
I am an abstract codec for encoding/decoding values stored in PunQLite database.

Responsibility:
- Define the encoding/decoding protocol for PqDatabase values
- Subclasses implement specific encoding strategies (UTF-8, JSON, etc.)

Collaborators:
- PqDatabase: Uses codecs for value encoding/decoding
- PqCursor: Uses codecs for decoding values during iteration

Public API and Key Messages:
- #encode: anObject - Convert an object to ByteArray (subclassResponsibility)
- #decode: aByteArray - Convert ByteArray back to an object (subclassResponsibility)

Example:
  codec := PqUtf8Codec new.
  encoded := codec encode: 'Hello, 世界'.
  decoded := codec decode: encoded.  ""=> 'Hello, 世界'""
"
Class {
	#name : #PqCodec,
	#superclass : #Object,
	#category : #'PunQLite-DB-Codec'
}

{ #category : #encoding }
PqCodec >> decode: aByteArray [
	"Decode a ByteArray back to an object"

	^ self subclassResponsibility
]

{ #category : #encoding }
PqCodec >> encode: anObject [
	"Encode an object to a ByteArray"

	^ self subclassResponsibility
]
