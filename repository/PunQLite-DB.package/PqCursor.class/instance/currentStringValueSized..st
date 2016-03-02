accessig value
currentStringValueSized: valueBufferSize
	| intHolder ourStr ret |
	intHolder := UnQLiteFFI newIntHolder: valueBufferSize.
	ourStr := (ExternalAddress fromString: (String new: valueBufferSize)) autoRelease.
	ret := self currentValue: ourStr sized: intHolder.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal].
	^ourStr readString.