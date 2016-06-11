factory
newStructure: aString array: aCollection 
	| newStructure |
	newStructure := self newStructure: aString.
	aCollection do: [ :each | newStructure add: each ].
	^ newStructure