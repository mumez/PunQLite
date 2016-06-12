enumerating
detect: aBlock
	"Answer first document that matches aBlock.
	 NOTE: Since unqlite does not have a 'detect' function, we need to simulate like this... 
	 which is not the best, but works"
	^ (self select: aBlock) 
		ifNotEmpty: [ :result | result first ]
		ifEmpty: [ nil ]