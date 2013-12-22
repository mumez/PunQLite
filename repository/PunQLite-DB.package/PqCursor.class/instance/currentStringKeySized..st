accessing key
currentStringKeySized: keyBufferSize
	| ourStr intHolder ret |
	intHolder := UnQLiteFFI newIntHolder: keyBufferSize.
	ourStr := NBExternalAddress fromString: (String new: keyBufferSize).
	ret := self currentKey: ourStr sized: intHolder.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal].
	^ourStr readString.
