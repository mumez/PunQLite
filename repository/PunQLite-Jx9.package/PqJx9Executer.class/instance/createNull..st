factory
createNull: anUndefinedObject
	^ (self newScalar: nil)
		clear;
		yourself