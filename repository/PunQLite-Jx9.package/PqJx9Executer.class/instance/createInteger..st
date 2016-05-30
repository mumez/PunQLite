factory
createInteger: anInteger
	^ (self newScalar: nil)
		asInt: anInteger;
		yourself