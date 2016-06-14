tests
testSizeOf
	| collection |
	
	collection := PqDatabase openOnMemory collectionName: 'customers'.
	
	1 to: 10 do: [ :index | 
		collection add: { 
			'name' -> ('John Doe ', index printString). 
			'account' -> (index * 10000). 
			'amount' -> (index * 10000.0) } asDictionary ].
		
	self assert: (collection sizeOf: [ :each | (each at: 'amount') <= 50000.0 ]) equals: 5.
	
	collection add: { 'name' -> 'John Doe'. 'account' -> 1. 'amount' -> nil } asDictionary.
	
	self assert: collection size equals: 11.
	
	collection removeAt: 0.
	
	self assert: collection size equals: 10.
