actions
last
	| ret |
	ret := self ffi lastEntryOn: self handle.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal]