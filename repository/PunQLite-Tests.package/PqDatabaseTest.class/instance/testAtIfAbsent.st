testing
testAtIfAbsent
	"self debug: #testAtIfAbsent"
	| fetched |

	self database at: 'Smalltalk' put: 'COOL'.
	
	fetched := self database 
		at: 'Smalltalk' 
		ifAbsent: [:data | fetched := 'Not Found' ].
	self assert: fetched asString equals: 'COOL'.
	
	fetched := nil.
	self database 
		at: 'Pharo' 
		ifAbsent: [ fetched := 'Not Found' ].
	self assert: fetched equals: 'Not Found'