seeking
seek: key untilBeginDo: aBlock
	(self seek: key) ifTrue: [self fromCurrentReverseDo: aBlock]