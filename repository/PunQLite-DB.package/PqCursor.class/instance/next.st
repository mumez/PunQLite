actions
next
	| ret |
	ret := ffi nextEntryOn: self handle.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal]