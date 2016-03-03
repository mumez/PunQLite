testing
testStoreDelete
	"self debug: #testStoreDelete"
	| ok fetched deleted |

	ok := self database storeAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	fetched := self database fetchStringAt: 'Smalltalk'.
	self assert: fetched equals: 'COOL'.
	
	deleted := self database deleteAt: 'Smalltalk'.
	self assert: deleted.
	self 
		should: [ self database fetchStringAt: 'Smalltalk'] 
		raise: PqFetchError.
	
	ok := self database storeAt: 'Pharo' value: 'HOT' asByteArray.
	self assert: ok.
	
	fetched := self database fetchAt: 'Pharo'.
	self assert: fetched equals: 'HOT' asByteArray.
	
	deleted := self database deleteAt: 'Pharo'.
	self assert: deleted.
	self 
		should: [ self database fetchAt: 'Pharo'] 
		raise: PqFetchError