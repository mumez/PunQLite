enumerating
detect: aBlock
	"Since unqlite does not have a 'detect' function, we need to simulate like this... which is 
	 not the best."
	^ (self select: aBlock) 
		ifNotEmpty: [ :result | result first ]
		ifEmpty: [ nil ]