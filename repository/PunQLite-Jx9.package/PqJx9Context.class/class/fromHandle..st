instance creation
fromHandle: aHandle
	^ self basicNew 
		initializeHandle: aHandle;
		yourself