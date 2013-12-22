enumeration
do: aBlock
	self first.
	[self currentIsValid] whileTrue: [
		aBlock value: self.
		self next.
	]