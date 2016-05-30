seeking
seek: key by: seekOption
	| ret |
	ret := self ffi 
		seekKey: key 
		sized: key size 
		on: self handle by: seekOption.
	(self isOk: ret) ifTrue: [^true].
	(ret = NOTFOUND or: [ret = EOF]) ifTrue: [^false].
	
	(PqCursorError code: ret cursor: self) signal