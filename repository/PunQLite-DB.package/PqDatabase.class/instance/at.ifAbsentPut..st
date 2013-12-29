actions-dictionary
at: key ifAbsentPut: aBlock
	^ [ self fetchAt: key ]
		on: PqFetchError
		do: [ :ex | 
			ex isNotFound 
				ifTrue: [ self at: key put: aBlock value ]
				ifFalse: [ ex pass ] ]