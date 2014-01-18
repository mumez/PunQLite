actions
previous
	| ret |
	ret := ffi previousEntryOn: self handle.
	(self isOkOrDone: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal]