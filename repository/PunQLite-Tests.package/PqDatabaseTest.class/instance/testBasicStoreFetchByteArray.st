testing
testBasicStoreFetchByteArray
	"self debug: #testBasicStoreFetchByteArray"
	| ok fetched |

	ok := self database storeAt: 'Smalltalk' value: 'COOL' asByteArray.
	self assert: ok.
	
	fetched := self database fetchAt: 'Smalltalk'.
	self assert: fetched equals: 'COOL' asByteArray