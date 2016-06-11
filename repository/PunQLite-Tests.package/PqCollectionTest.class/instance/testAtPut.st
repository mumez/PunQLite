tests
testAtPut
	| collection result |
	
	collection := PqDatabase openOnMemory collectionName: 'customers'.
	
	1 to: 10 do: [ :index | 
		collection add: { 
			'name' -> ('John Doe ', index printString). 
			'account' -> (index * 10000). 
			'amount' -> (index * 10000.0) } asDictionary ].
		
	collection at: 4 put: { 
		'name' -> 'Jane Smith'. 
		'account' -> 1234567890. 
		'amount' -> 123456789.0 } asDictionary.
	
	result := collection at: 4.
		
	self assert: (result at: '__id') equals: 4.
	self assert: (result at: 'name') equals: 'Jane Smith'.
	self assert: (result at: 'account') equals: 1234567890. 
	self assert: (result at: 'amount') equals: 123456789.0