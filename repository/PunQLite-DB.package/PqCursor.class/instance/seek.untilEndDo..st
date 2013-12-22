seeking
seek: key untilEndDo: aBlock
	(self seek: key) ifTrue: [self fromCurrentDo: aBlock]