actions
extract: varName
	| rawValueHandle |
	self compiled ifFalse: [^nil].
	self executed ifFalse: [^nil].
	rawValueHandle := ffi extract: varName on: self handle.
	rawValueHandle ifNil: [^nil].
	^PqJx9Value named: varName on: rawValueHandle 