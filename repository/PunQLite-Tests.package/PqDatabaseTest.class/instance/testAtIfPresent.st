testing
testAtIfPresent
	"self debug: #testAtIfPresent"
	| fetched |

	self database at: 'Smalltalk' put: 'COOL'.
	
	self database
		at: 'Smalltalk' 
		ifPresent: [:data | fetched := data asString ].
	self assert: fetched equals: 'COOL'.
	
	fetched := nil.
	self database 
		at: 'Pharo' 
		ifPresent: [:data | fetched := data asString ].
	self assert: fetched isNil