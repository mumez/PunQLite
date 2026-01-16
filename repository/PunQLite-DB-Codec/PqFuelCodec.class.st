"
I encode and decode arbitrary objects using Fuel binary serialization.

Responsibility:
- Convert arbitrary Smalltalk objects to Fuel-serialized ByteArrays
- Convert Fuel-serialized ByteArrays back to Smalltalk objects

Collaborators:
- FLSerializer: Used for binary serialization
- FLMaterializer: Used for binary deserialization
- PqCodec: My superclass defining the encoding protocol
- PqDatabase: Used when storing complex Smalltalk objects

Public API and Key Messages:
- #encode: anObject - Serialize object to ByteArray using Fuel
- #decode: aByteArray - Deserialize ByteArray to object using Fuel

Example:
  codec := PqFuelCodec new.
  encoded := codec encode: (OrderedCollection with: 1 with: 2 with: 3).
  decoded := codec decode: encoded.  ""=> an OrderedCollection(1 2 3)""

  ""Fuel preserves object identity and class types""
  original := Set with: 'a' with: 'b'.
  decoded := codec decode: (codec encode: original).
  decoded class = Set.  ""=> true""
"
Class {
	#name : #PqFuelCodec,
	#superclass : #PqCodec,
	#category : #'PunQLite-DB-Codec'
}

{ #category : #encoding }
PqFuelCodec >> decode: aByteArray [
	"Deserialize a Fuel-encoded ByteArray to a Smalltalk object"

	^ FLMaterializer materializeFromByteArray: aByteArray
]

{ #category : #encoding }
PqFuelCodec >> encode: anObject [
	"Serialize a Smalltalk object to a Fuel-encoded ByteArray"

	^ FLSerializer serializeToByteArray: anObject
]
