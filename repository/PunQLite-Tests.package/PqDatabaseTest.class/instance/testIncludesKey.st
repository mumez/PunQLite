testing
testIncludesKey
	"self debug: #testIncludesKey"
	| ok fetched |

	ok := self database storeAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	ok := self database includesKey: 'Smalltalk'.
	self assert: ok.
	
	ok := self database includesKey: 'Pharo'.
	self assert: ok not.
	
	fetched := self database fetchStringAt: 'Smalltalk'.
	self assert: fetched equals: 'COOL'