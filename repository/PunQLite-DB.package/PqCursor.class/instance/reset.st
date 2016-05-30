actions
reset
	| ret |
	ret := self ffi resetCursor: self handle.
	(self isOk: ret) ifFalse: [(PqCursorError code: ret cursor: self) signal]