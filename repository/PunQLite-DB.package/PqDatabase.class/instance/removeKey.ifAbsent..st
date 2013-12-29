actions-dictionary
removeKey: key ifAbsent: aBlock
	^ [ self removeKey: key]
		on: PqUpdateError
		do: [ :ex | 
			ex isNotFound 
				ifTrue: [aBlock value ]
				ifFalse: [ ex pass ] ]