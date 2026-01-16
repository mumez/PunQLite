"
Tests for PqCodec and PqUtf8Codec classes.
"
Class {
	#name : #PqCodecTest,
	#superclass : #TestCase,
	#category : #'PunQLite-Tests-Codec'
}

{ #category : #testing }
PqCodecTest >> testUtf8CodecDecodeByteArray [
	| codec decoded |

	codec := PqUtf8Codec new.
	decoded := codec decode: 'Hello' utf8Encoded.
	self assert: decoded equals: 'Hello'
]

{ #category : #testing }
PqCodecTest >> testUtf8CodecEncodeString [
	| codec encoded |

	codec := PqUtf8Codec new.
	encoded := codec encode: 'Hello'.
	self assert: encoded equals: 'Hello' utf8Encoded
]

{ #category : #testing }
PqCodecTest >> testUtf8CodecMultiByteCharacters [
	| codec japanese chinese emoji |

	codec := PqUtf8Codec new.

	japanese := 'こんにちは'.
	self assert: (codec decode: (codec encode: japanese)) equals: japanese.

	chinese := '你好世界'.
	self assert: (codec decode: (codec encode: chinese)) equals: chinese.

	emoji := '👋🌍'.
	self assert: (codec decode: (codec encode: emoji)) equals: emoji
]

{ #category : #testing }
PqCodecTest >> testUtf8CodecRoundtrip [
	| codec original |

	codec := PqUtf8Codec new.
	original := 'Hello, 世界! 👋'.
	self assert: (codec decode: (codec encode: original)) equals: original
]
