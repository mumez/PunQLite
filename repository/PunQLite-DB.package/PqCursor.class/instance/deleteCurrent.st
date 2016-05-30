actions
deleteCurrent
	| ret |
	ret := self ffi deleteEntryOn: self handle.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal]