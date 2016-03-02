accessing key
currentStringKeySized: keyBufferSize
	| ourStr intHolder ret |
	intHolder := UnQLiteFFI newIntHolder: keyBufferSize.
	ourStr := (ExternalAddress fromString: (String new: keyBufferSize)) autoRelease.
	ret := self currentKey: ourStr sized: intHolder.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal].
	^ourStr readString.
