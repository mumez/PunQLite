tests
testAt
	| collection result |
	
	collection := PqDatabase openOnMemory collectionName: 'customers'.
	
	1 to: 10 do: [ :index | 
		collection add: { 
			'name' -> ('John Doe ', index printString). 
			'account' -> (index * 10000). 
			'amount' -> (index * 10000.0) } asDictionary ].
		
	result := collection at: 4.
		
	self assert: (result at: '__id') equals: 4.
	self assert: (result at: 'name') equals: 'John Doe 5'.