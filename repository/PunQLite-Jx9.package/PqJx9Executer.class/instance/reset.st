actions
reset
	| ret |
	ret := ffi resetExecutionOn: self handle.
	^self isOk: ret