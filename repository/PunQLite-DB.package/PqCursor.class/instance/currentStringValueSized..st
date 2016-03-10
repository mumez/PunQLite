accessig value
currentStringValueSized: valueBufferSize
	| intHolder ourStr ret |
	intHolder := UnQLiteFFI newIntHolder: valueBufferSize.
	ourStr := ByteArray new: valueBufferSize.
	ret := self currentValue: ourStr sized: intHolder.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal].
	^ourStr readString