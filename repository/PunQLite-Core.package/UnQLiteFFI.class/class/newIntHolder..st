factory
newIntHolder: anInteger
	| holder |
	holder := self newIntHolder.
	holder value: anInteger.
	^holder