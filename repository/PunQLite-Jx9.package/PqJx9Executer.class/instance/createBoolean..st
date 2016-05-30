factory
createBoolean: aBoolean
	^ (self newScalar: nil)
		asBool: aBoolean;
		yourself