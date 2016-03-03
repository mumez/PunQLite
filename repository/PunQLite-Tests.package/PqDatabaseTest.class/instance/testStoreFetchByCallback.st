testing
testStoreFetchByCallback
	"self debug: #testStoreFetchByCallback"
	| ok fetched |
	
	ok := self database storeAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	self database 
		fetchAt: 'Smalltalk' 
		basicInto: [ :dataAddr :dataSize :userData |
			| data |
			self assert: dataSize equals: 'COOL' size.
			data := ByteArray new: dataSize.
			LibC memCopy: dataAddr to: data size: dataSize.
			self assert: data asString equals: 'COOL'.
			0 ].
	
	self database 
		fetchAt: 'Smalltalk' 
		into: [:data | fetched := data asString ].
	self assert: fetched equals: 'COOL'