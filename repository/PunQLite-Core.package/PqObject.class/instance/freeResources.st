initialize-release
freeResources
	(handle isNil or: [ handle isNull ]) 
		ifTrue: [ ^ self ].
	
	[self release]
 	ensure: [
		handle free.
		handle beNull ]