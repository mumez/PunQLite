factory
newStructure: aString json: aDictionary 
	| newStructure |
	newStructure := self newStructure: aString.
	aDictionary keysAndValuesDo: [ :key :value | 
		newStructure at: key put: value ].
	^ newStructure