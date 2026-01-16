"
Tests for PqJsonCodec class.
"
Class {
	#name : #PqJsonCodecTest,
	#superclass : #TestCase,
	#category : #'PunQLite-Tests-Codec'
}

{ #category : #testing }
PqJsonCodecTest >> testJsonCodecDecodeArray [
	| codec decoded |

	codec := PqJsonCodec new.
	decoded := codec decode: '["Alice","Bob","Charlie"]' utf8Encoded.
	self assert: decoded equals: #('Alice' 'Bob' 'Charlie')
]

{ #category : #testing }
PqJsonCodecTest >> testJsonCodecDecodeDictionary [
	| codec decoded |

	codec := PqJsonCodec new.
	decoded := codec decode: '{"name":"Alice","age":30}' utf8Encoded.
	self assert: (decoded at: 'name') equals: 'Alice'.
	self assert: (decoded at: 'age') equals: 30
]

{ #category : #testing }
PqJsonCodecTest >> testJsonCodecEncodeArray [
	| codec encoded |

	codec := PqJsonCodec new.
	encoded := codec encode: #('Alice' 'Bob' 'Charlie').
	self assert: encoded equals: '["Alice","Bob","Charlie"]' utf8Encoded
]

{ #category : #testing }
PqJsonCodecTest >> testJsonCodecEncodeDictionary [
	| codec encoded decoded |

	codec := PqJsonCodec new.
	encoded := codec encode: (Dictionary new at: 'name' put: 'Alice'; yourself).
	decoded := STONJSON fromString: encoded utf8Decoded.
	self assert: (decoded at: 'name') equals: 'Alice'
]

{ #category : #testing }
PqJsonCodecTest >> testJsonCodecRoundtripArray [
	| codec original |

	codec := PqJsonCodec new.
	original := #('Alice' 'Bob' 'Charlie').
	self assert: (codec decode: (codec encode: original)) equals: original
]

{ #category : #testing }
PqJsonCodecTest >> testJsonCodecRoundtripComplex [
	| codec original decoded |

	codec := PqJsonCodec new.
	original := Dictionary new
		at: 'users' put: #('Alice' 'Bob');
		at: 'count' put: 2;
		at: 'active' put: true;
		yourself.
	decoded := codec decode: (codec encode: original).
	self assert: (decoded at: 'users') equals: #('Alice' 'Bob').
	self assert: (decoded at: 'count') equals: 2.
	self assert: (decoded at: 'active') equals: true
]

{ #category : #testing }
PqJsonCodecTest >> testJsonCodecRoundtripDictionary [
	| codec original decoded |

	codec := PqJsonCodec new.
	original := Dictionary new at: 'name' put: 'Alice'; at: 'age' put: 30; yourself.
	decoded := codec decode: (codec encode: original).
	self assert: (decoded at: 'name') equals: 'Alice'.
	self assert: (decoded at: 'age') equals: 30
]
