actions-dictionary
removeKey: key
	| ret |
	ret := ffi delete: self handle key: key sized: key size.
	(self isOk: ret) ifFalse: [(PqUpdateError code: ret key: key) signal].
	^key
	