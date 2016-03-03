initialize-release
freeResources
	(handle isNil or: [ handle isNull ]) 
		ifTrue: [ ^ self ].
	
	handle free.
	handle beNull