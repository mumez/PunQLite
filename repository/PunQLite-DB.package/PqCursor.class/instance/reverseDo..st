enumeration
reverseDo: aBlock
	self last.
	[self currentIsValid] whileTrue: [
		aBlock value: self.
		self previous.
	]