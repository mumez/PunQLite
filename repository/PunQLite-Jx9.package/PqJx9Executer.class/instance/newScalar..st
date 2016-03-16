actions
newScalar: aName
	| rawValueHandle |
	rawValueHandle := ffi newScalar: self handle.
	rawValueHandle ifNil: [ ^nil ].
	^PqJx9Value named: aName on: rawValueHandle
	
