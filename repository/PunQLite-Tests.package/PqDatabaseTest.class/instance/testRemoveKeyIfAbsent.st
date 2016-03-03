testing
testRemoveKeyIfAbsent
	"self debug: #testRemoveKeyIfAbsent"
	| fetched altValue |

	self database at: 'Smalltalk' put: 'COOL'.
	
	fetched := self database at: 'Smalltalk'.
	self assert: fetched asString equals: 'COOL'.
	
	self database removeKey: 'Smalltalk'.
	self deny: (self database includesKey: 'Smalltalk').
	
	altValue := self database removeKey: 'Smalltalk' ifAbsent: ['Pharo'].
	self assert: altValue asString equals: 'Pharo'.
	self deny: (self database includesKey: 'Smalltalk')