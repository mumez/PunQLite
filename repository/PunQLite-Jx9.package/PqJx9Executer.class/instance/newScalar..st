actions
newScalar: aName
	| rawValueHandle |
	rawValueHandle := self ffi newScalar: self handle.
	rawValueHandle ifNil: [ ^nil ].
	^PqJx9Value named: aName on: rawValueHandle
	
