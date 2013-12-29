actions
previous
	| ret |
	ret := ffi previousEntryOn: self handle.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal]