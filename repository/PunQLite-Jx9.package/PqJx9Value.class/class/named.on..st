instance creation
named: varName on: rawValueHandle 
	^ self new
		name: varName;
		handle: rawValueHandle;
		yourself