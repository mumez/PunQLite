actions-dictionary
includesKey: key
	|  intHolder bytes ret |
	intHolder := UnQLiteFFI newIntHolder: 1.
	bytes := #[0].
	ret := ffi fetch: self handle key: key sized: key size value: bytes sized: intHolder.
	^self isOk: ret