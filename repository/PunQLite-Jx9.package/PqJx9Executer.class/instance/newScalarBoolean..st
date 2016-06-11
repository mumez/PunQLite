factory
newScalarBoolean: aBoolean
	^ (self newScalar: nil)
		asBool: aBoolean;
		yourself