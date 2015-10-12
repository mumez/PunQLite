private - filtering
keysFilterPattern: aRxMatcher 
	 
	 self keysModel items: 
		(aRxMatcher isNil ifTrue: [self database keys ]
					    ifFalse: [ self database keys select: [ :each| aRxMatcher search: each asString ]]).

	 