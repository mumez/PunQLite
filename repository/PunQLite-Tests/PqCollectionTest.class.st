Class {
	#name : #PqCollectionTest,
	#superclass : #TestCase,
	#category : 'PunQLite-Tests-Database'
}

{ #category : #tests }
PqCollectionTest >> testAdd [
	| collection json result id |
	
	collection := PqDatabase openOnMemory collectionName: 'customers'.
	json := { 'name' -> 'John Doe'. 'account' -> 1234567890. 'amount' -> 12345678.90 } asDictionary.
	id := collection add: json.
	self assert: id equals: 0. "first id"
		
	result := collection selectAll.
	self assert: result size equals: 1.
	result first removeKey: '__id'.
	self assert: result first equals: json. 
]

{ #category : #tests }
PqCollectionTest >> testAt [
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
	
	result := collection at: 42. "Do not exists"
	self assert: result isNil	

]

{ #category : #tests }
PqCollectionTest >> testAtPut [
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
]

{ #category : #tests }
PqCollectionTest >> testDetect [
	| collection result |
	
	collection := PqDatabase openOnMemory collectionName: 'customers'.
	
	1 to: 10 do: [ :index | 
		collection add: { 
			'name' -> ('John Doe ', index printString). 
			'account' -> (index * 10000). 
			'amount' -> (index * 10000.0) } asDictionary ].
		
	result := collection detect: [ :each | (each at: 'account') = 50000 ].
	self assert: (result at: 'name') equals: 'John Doe 5'.
]

{ #category : #tests }
PqCollectionTest >> testRemoveAt [
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
]

{ #category : #tests }
PqCollectionTest >> testSelect [
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
]

{ #category : #tests }
PqCollectionTest >> testSelectAll [
	| collection result |
	
	collection := PqDatabase openOnMemory collectionName: 'customers'.
	
	1 to: 10 do: [ :index | 
		collection add: { 
			'name' -> ('John Doe ', index printString). 
			'account' -> (index * 10000). 
			'amount' -> (index * 10000.0) } asDictionary ].
		
	result := collection selectAll.
	self assert: result size equals: 10.
	result withIndexDo: [ :each :index |
		self assert: (each at: 'name') equals: 'John Doe ', index printString.
		self assert: (each at: 'account') equals: index * 10000.
		self assert: (each at: 'amount') equals: index * 10000.0 ].
	
]

{ #category : #tests }
PqCollectionTest >> testSize [
	| collection |
	
	collection := PqDatabase openOnMemory collectionName: 'customers'.
	
	1 to: 10 do: [ :index | 
		collection add: { 
			'name' -> ('John Doe ', index printString). 
			'account' -> (index * 10000). 
			'amount' -> (index * 10000.0) } asDictionary ].
		
	self assert: collection size equals: 10.
	
	collection add: { 'name' -> 'John Doe'. 'account' -> 1. 'amount' -> nil } asDictionary.
	
	self assert: collection size equals: 11.
	
	collection removeAt: 0.
	
	self assert: collection size equals: 10.

]

{ #category : #tests }
PqCollectionTest >> testSizeOf [
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

]
