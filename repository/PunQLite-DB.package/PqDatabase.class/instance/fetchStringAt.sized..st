actions
fetchStringAt: key sized: valueBufSize
	|  intHolder ourStr ret |
	intHolder := UnQLiteFFI newIntHolder: valueBufSize.
	ourStr := NBExternalAddress fromString: (String new: valueBufSize).
	ret := ffi fetch: self handle key: key sized: key size value: ourStr sized: intHolder.
	(self isOk: ret) ifFalse: [(PqFetchError code: ret key: key) signal].
	^ ourStr readString.
	