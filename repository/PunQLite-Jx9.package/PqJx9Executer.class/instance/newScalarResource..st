factory
newScalarResource: aByteArray
	^ (self newScalar: nil)
		asResource: aByteArray;
		yourself