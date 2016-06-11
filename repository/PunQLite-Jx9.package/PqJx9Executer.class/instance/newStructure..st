factory
newStructure: aName
	| rawValueHandle |
	rawValueHandle := self ffi newStructure: self handle.
	rawValueHandle ifNil: [ ^nil ].
	^(PqJx9Value named: aName on: rawValueHandle) executer: self; yourself
	
