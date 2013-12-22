enumeration
fromCurrentDo: aBlock
	[self currentIsValid] whileTrue: [
		aBlock value: self.
		self next.
	]