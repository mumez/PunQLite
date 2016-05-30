actions
fetchAt: key sized: valueBufSize
	|  intHolder bytes ret |
	intHolder := UnQLiteFFI newIntHolder: valueBufSize.
	bytes := ByteArray new: valueBufSize.
	ret := self ffi 
		fetch: self handle 
		key: key 
		sized: key size 
		value: bytes 
		sized: intHolder.
	(self isOk: ret) ifFalse: [(PqFetchError code: ret key: key) signal].
	^ bytes copyFrom: 1 to: intHolder value