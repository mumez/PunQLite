actions
at: aKey put: aValue
	| value release ret |
	
	(aValue isKindOf: PqJx9Value) 
		ifTrue: [ value := aValue. release := false ]
		ifFalse: [ 
			| v |
			release := true.
			v := self executer newScalar: (executer database getRandomStringSized: 10).
			(aValue isKindOf: Float)
				ifTrue: [ v asDouble: aValue ]
				ifFalse: [ 
					(aValue isKindOf: Integer)
						ifTrue: [ v asInt64: aValue ]
						ifFalse: [ 
							(aValue isKindOf: String)
								ifTrue: [ v asString: aValue ]
								ifFalse: [ 
									(aValue isKindOf: Boolean)
										ifTrue: [ v asBool: aValue ]
										ifFalse: [ PqJx9Error signal: 'Cannot store value of class ', aValue class asString ]]]].
			value := v ].
	ret := ffi structure: self handle atKey: aKey putValue: value handle.
	release ifTrue: [ self executer release: value ].
	^ ret
	