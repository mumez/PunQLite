actions
first
	| ret |
	ret := ffi firstEntryOn: self handle.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal]	