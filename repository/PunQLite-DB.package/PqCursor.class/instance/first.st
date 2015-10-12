actions
first
	| ret |
	ret := ffi firstEntryOn: self handle.
	(self isOk: ret) ifFalse: [
		(self isDone: ret) ifFalse: [ (PqCursorError code: ret cursor: self) signal ]]	