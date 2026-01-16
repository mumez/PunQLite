"
Tests for PqFuelCodec class.
"
Class {
	#name : #PqFuelCodecTest,
	#superclass : #TestCase,
	#category : #'PunQLite-Tests-Codec'
}

{ #category : #testing }
PqFuelCodecTest >> testFuelCodecDecodeByteArray [
	| codec original encoded decoded |

	codec := PqFuelCodec new.
	original := #(1 2 3).
	encoded := FLSerializer serializeToByteArray: original.
	decoded := codec decode: encoded.
	self assert: decoded equals: original
]

{ #category : #testing }
PqFuelCodecTest >> testFuelCodecEncodeArray [
	| codec encoded decoded |

	codec := PqFuelCodec new.
	encoded := codec encode: #('a' 'b' 'c').
	decoded := FLMaterializer materializeFromByteArray: encoded.
	self assert: decoded equals: #('a' 'b' 'c')
]

{ #category : #testing }
PqFuelCodecTest >> testFuelCodecPreservesClass [
	| codec original decoded |

	codec := PqFuelCodec new.

	"OrderedCollection"
	original := OrderedCollection with: 1 with: 2 with: 3.
	decoded := codec decode: (codec encode: original).
	self assert: decoded class equals: OrderedCollection.
	self assert: decoded asArray equals: #(1 2 3).

	"Set"
	original := Set with: 'x' with: 'y'.
	decoded := codec decode: (codec encode: original).
	self assert: decoded class equals: Set.
	self assert: (decoded includes: 'x').
	self assert: (decoded includes: 'y')
]

{ #category : #testing }
PqFuelCodecTest >> testFuelCodecRoundtripArray [
	| codec original |

	codec := PqFuelCodec new.
	original := #(1 2 3 'hello' true).
	self assert: (codec decode: (codec encode: original)) equals: original
]

{ #category : #testing }
PqFuelCodecTest >> testFuelCodecRoundtripDictionary [
	| codec original decoded |

	codec := PqFuelCodec new.
	original := Dictionary new
		at: 'name' put: 'Alice';
		at: 'age' put: 30;
		yourself.
	decoded := codec decode: (codec encode: original).
	self assert: (decoded at: 'name') equals: 'Alice'.
	self assert: (decoded at: 'age') equals: 30
]

{ #category : #testing }
PqFuelCodecTest >> testFuelCodecRoundtripNested [
	| codec original decoded |

	codec := PqFuelCodec new.
	original := Dictionary new
		at: 'users' put: (OrderedCollection with: 'Alice' with: 'Bob');
		at: 'config' put: (Dictionary new at: 'timeout' put: 30; yourself);
		yourself.
	decoded := codec decode: (codec encode: original).
	self assert: (decoded at: 'users') class equals: OrderedCollection.
	self assert: (decoded at: 'users') asArray equals: #('Alice' 'Bob').
	self assert: ((decoded at: 'config') at: 'timeout') equals: 30
]
