factory
createDouble: aFloat
	^ (self newScalar: nil)
		asDouble: aFloat;
		yourself