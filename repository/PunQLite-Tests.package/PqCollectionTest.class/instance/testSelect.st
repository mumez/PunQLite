tests
testSelect
	| collection result |
	
	collection := PqDatabase openOnMemory collectionName: 'customers'.
	
	1 to: 10 do: [ :index | 
		collection add: { 
			'name' -> ('John Doe ', index printString). 
			'account' -> (index * 10000). 
			'amount' -> (index * 10000.0) } asDictionary ].
		
	result := collection select: [ :each | (each at: 'account') <= 50000 ].
	self assert: result size equals: 5.
	result withIndexDo: [ :each :index |
		self assert: (each at: 'name') equals: 'John Doe ', index printString.
		self assert: (each at: 'account') equals: index * 10000.
		self assert: (each at: 'amount') equals: index * 10000.0 ].