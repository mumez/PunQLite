tests
testRemoveAt
	| collection result |
	
	collection := PqDatabase openOnMemory collectionName: 'customers'.
	
	1 to: 10 do: [ :index | 
		collection add: { 
			'name' -> ('John Doe ', index printString). 
			'account' -> (index * 10000). 
			'amount' -> (index * 10000.0) } asDictionary ].
		
	collection removeAt: 4.
		
	result := collection selectAll.
	self assert: result size equals: 9.
	self assert: (result noneSatisfy: [ :each | (each at: '__id') = 4 ] ).
	self assert: (result noneSatisfy: [ :each | (each at: 'name') = 'John Doe 5' ] ).