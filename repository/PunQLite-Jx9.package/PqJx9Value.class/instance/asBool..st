actions
asBool: aBoolean
	^ffi setValue: self handle boolean: (aBoolean ifTrue: [ 1 ] ifFalse: [ 0 ])