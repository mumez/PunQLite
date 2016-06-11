tests
testAdd
	| collection json result |
	
	collection := PqDatabase openOnMemory collectionName: 'customers'.
	json := { 'name' -> 'John Doe'. 'account' -> 1234567890. 'amount' -> 12345678.90 } asDictionary.
	collection add: json.
		
	result := collection selectAll.
	self assert: result size equals: 1.
	result first removeKey: '__id'.
	self assert: result first equals: json. 