testing
testAppendByteArray
	"self debug: #testAppendByteArray"
	| ok fetched |

	ok := self database appendAt: 'Smalltalk' value: 'COOL' asByteArray.
	self assert: ok.
	
	ok := self database appendAt: 'Smalltalk' value: 'COOL' asByteArray.
	self assert: ok.
	
	fetched := self database fetchAt: 'Smalltalk'.
	self assert: fetched equals: 'COOLCOOL' asByteArray