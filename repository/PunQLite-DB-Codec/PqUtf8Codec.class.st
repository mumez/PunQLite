"
I encode and decode string values using UTF-8 encoding.

Responsibility:
- Convert strings to UTF-8 encoded ByteArrays
- Convert UTF-8 ByteArrays back to strings

Collaborators:
- PqDatabase: Default codec for string storage
- PqCodec: My superclass defining the encoding protocol

Public API and Key Messages:
- #encode: anObject - Convert string to UTF-8 ByteArray
- #decode: aByteArray - Convert UTF-8 ByteArray to string

Example:
  codec := PqUtf8Codec new.
  encoded := codec encode: 'Hello, 世界'.
  decoded := codec decode: encoded.  ""=> 'Hello, 世界'""
"
Class {
	#name : #PqUtf8Codec,
	#superclass : #PqCodec,
	#category : #'PunQLite-DB-Codec'
}

{ #category : #encoding }
PqUtf8Codec >> decode: aByteArray [
	"Decode a UTF-8 ByteArray to a string"

	^ aByteArray utf8Decoded
]

{ #category : #encoding }
PqUtf8Codec >> encode: anObject [
	"Encode an object to a UTF-8 ByteArray"

	^ anObject utf8Encoded
]
