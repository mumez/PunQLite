factory
newScalarInteger: anInteger
	^ (self newScalar: nil)
		asInt: anInteger;
		yourself