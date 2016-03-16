testing
testAppendString
	"self debug: #testAppendString"
	| ok fetched |
	
	ok := self database appendAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	ok := self database appendAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	fetched := self database fetchStringAt: 'Smalltalk'.
	self assert: fetched equals: 'COOLCOOL'