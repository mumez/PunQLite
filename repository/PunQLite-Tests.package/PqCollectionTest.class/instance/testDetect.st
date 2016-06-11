tests
testDetect
	| collection result |
	
	collection := PqDatabase openOnMemory collectionName: 'customers'.
	
	1 to: 10 do: [ :index | 
		collection add: { 
			'name' -> ('John Doe ', index printString). 
			'account' -> (index * 10000). 
			'amount' -> (index * 10000.0) } asDictionary ].
		
	result := collection detect: [ :each | (each at: 'account') = 50000 ].
	self assert: (result at: 'name') equals: 'John Doe 5'.