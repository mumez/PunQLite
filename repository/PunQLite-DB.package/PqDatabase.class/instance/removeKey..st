actions-dictionary
removeKey: key
	| ret |
	ret := self ffi delete: self handle key: key sized: key size.
	(self isOk: ret) ifFalse: [(PqUpdateError code: ret key: key) signal].
	^key
	