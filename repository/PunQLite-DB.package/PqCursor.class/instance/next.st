actions
next
	| ret |
	ret := self ffi nextEntryOn: self handle.
	(self isOkOrDone: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal]