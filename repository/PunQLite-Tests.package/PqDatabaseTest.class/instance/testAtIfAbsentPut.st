testing
testAtIfAbsentPut
	"self debug: #testAtIfAbsentPut"
	| fetched |

	self database at: 'Smalltalk' put: 'COOL'.
	
	fetched := self database at: 'Smalltalk'.
	self assert: fetched asString equals: 'COOL'.
	
	self database removeKey: 'Smalltalk'.
	self deny: (self database includesKey: 'Smalltalk').
	
	self database at: 'Smalltalk' ifAbsentPut: [ 'cool' asUppercase ].
	fetched := self database at: 'Smalltalk' ifAbsent: [ 'cool??' ].
		
	self assert: fetched asString equals: 'COOL'