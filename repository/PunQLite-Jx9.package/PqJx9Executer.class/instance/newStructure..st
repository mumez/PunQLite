actions
newStructure: aName
	| rawValueHandle |
	rawValueHandle := ffi newStructure: self handle.
	rawValueHandle ifNil: [ ^nil ].
	^(PqJx9Value named: aName on: rawValueHandle) executer: self; yourself
	
