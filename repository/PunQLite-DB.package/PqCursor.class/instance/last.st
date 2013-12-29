actions
last
	| ret |
	ret := ffi lastEntryOn: self handle.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal]