actions
evaluate: aJx9Source
	self compiled ifFalse: [self compile: aJx9Source].
	^self execute