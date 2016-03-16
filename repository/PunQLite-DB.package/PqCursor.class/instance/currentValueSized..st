accessig value
currentValueSized: valueBufferSize
	| intHolder bytes ret |
	intHolder := UnQLiteFFI newIntHolder: valueBufferSize.
	bytes := ByteArray new: valueBufferSize.
	ret := self currentValue: bytes sized: intHolder.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal].
	^bytes copyFrom: 1 to: intHolder value