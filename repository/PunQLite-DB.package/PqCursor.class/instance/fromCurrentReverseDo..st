enumeration
fromCurrentReverseDo: aBlock
	[self currentIsValid] whileTrue: [
		aBlock value: self.
		self previous.
	]