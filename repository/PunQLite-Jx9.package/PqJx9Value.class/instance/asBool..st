actions
asBool: aBoolean
	^self ffi setValue: self handle boolean: (aBoolean ifTrue: [ 1 ] ifFalse: [ 0 ])