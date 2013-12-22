actions
compile: aJx9Source
	| ret |
	ret := ffi compile: aJx9Source sized: -1 into: self handle on: self dbHandle.
	(self isOk: ret) ifTrue: [
		compiled := true
	] ifFalse: [
		(PqJx9Error code: ret source: aJx9Source) signal
	].
	^compiled