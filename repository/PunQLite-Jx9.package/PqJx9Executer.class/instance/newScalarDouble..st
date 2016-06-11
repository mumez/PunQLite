factory
newScalarDouble: aFloat
	^ (self newScalar: nil)
		asDouble: aFloat;
		yourself