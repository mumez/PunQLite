factory
newScalarInteger64: anInteger
	^ (self newScalar: nil)
		asInt64: anInteger;
		yourself