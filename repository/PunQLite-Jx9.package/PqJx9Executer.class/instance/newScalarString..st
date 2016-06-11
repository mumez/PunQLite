factory
newScalarString: aString
	^ (self newScalar: nil)
		"resetStringCursor;"
		asString: aString;
		yourself