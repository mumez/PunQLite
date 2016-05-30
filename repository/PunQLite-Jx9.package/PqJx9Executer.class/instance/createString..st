factory
createString: aString
	^ (self newScalar: nil)
		resetStringCursor;
		asString: aString;
		yourself