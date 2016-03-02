actions
fetchStringAt: key sized: valueBufSize
	|  intHolder ourStr ret |
	intHolder := UnQLiteFFI newIntHolder: valueBufSize.
	ourStr := (ExternalAddress fromString: (String new: valueBufSize)) autoRelease.
	ret := ffi fetch: self handle key: key sized: key size value: ourStr sized: intHolder.
	(self isOk: ret) ifFalse: [(PqFetchError code: ret key: key) signal].
	^ ourStr readString.
	