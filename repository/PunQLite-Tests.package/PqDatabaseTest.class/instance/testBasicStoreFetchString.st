testing
testBasicStoreFetchString
	"self debug: #testBasicStoreFetchString"
	| ok fetched |

	ok := self database storeAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	fetched := self database fetchStringAt: 'Smalltalk'.
	self assert: fetched equals: 'COOL'