actions-dictionary
at: key ifPresent: aBlock
	self fetchAt: key into: aBlock.
	^key
	