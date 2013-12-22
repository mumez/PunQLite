actions-dictionary
at: key ifAbsent: aBlock
	^ [ self fetchAt: key ]
		on: PqFetchError
		do: [ :ex | 
			ex isNotFound 
				ifTrue: [ aBlock value ]
				ifFalse: [ ex pass ] ]