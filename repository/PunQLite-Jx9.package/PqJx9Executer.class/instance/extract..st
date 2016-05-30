actions
extract: varName
	| rawValueHandle |
	self compiled ifFalse: [^nil].
	self executed ifFalse: [^nil].
	rawValueHandle := self ffi extract: varName on: self handle.
	(rawValueHandle isNil or: [ rawValueHandle isNull]) ifTrue: [^nil].
	^PqJx9Value named: varName on: rawValueHandle 