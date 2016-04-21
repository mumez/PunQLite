factory
scalarInteger: anInteger
	^ (self newScalar: nil)
		asInt: anInteger;
		yourself