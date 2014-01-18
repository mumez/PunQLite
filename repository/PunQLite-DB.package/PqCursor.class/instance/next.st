actions
next
	| ret |
	ret := ffi nextEntryOn: self handle.
	(self isOkOrDone: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal]