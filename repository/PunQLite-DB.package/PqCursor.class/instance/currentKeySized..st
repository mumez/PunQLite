accessing key
currentKeySized: keyBufferSize
	| intHolder bytes ret |
	intHolder := UnQLiteFFI newIntHolder: keyBufferSize.
	bytes := ByteArray new: keyBufferSize.
	ret := self currentKey: bytes sized: intHolder.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal].
	^bytes copyFrom: 1 to: intHolder value.