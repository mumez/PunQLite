instance creation
named: varName on: rawValueHandle 
	| inst |
	inst := self new.
	inst name: varName.
	inst handle: rawValueHandle.
	^inst