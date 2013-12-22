seeking
seek: key by: seekOption
	| ret |
	ret := ffi seekKey: key sized: key size on: self handle by: seekOption.
	(self isOk: ret) ifTrue: [^true].
	(ret = UnQLiteConstants NOTFOUND or: [ret = UnQLiteConstants EOF]) ifTrue: [^false].
	
	(PqCursorError code: ret cursor: self) signal