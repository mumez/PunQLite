testing
testCursorCurrentReverseDo
	"self debug: #testCursorCurrentReverseDo"
	| ok cursor entries |

	1 to: 10 do: [:idx |
		ok := self database 
			storeAt: idx asString 
			value: 'value-', idx asString.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	cursor seek: '5'.
	
	entries := OrderedCollection new.
	cursor fromCurrentReverseDo: [ :theCursor |
		entries add: (theCursor currentStringKey -> theCursor currentStringValue) ].

	self assert: entries size equals: 5.
	self assert: (entries collect: #key) asArray equals: #('5' '4' '3' '2' '1').
	self assert: (entries collect: #value) asArray equals: #('value-5' 'value-4' 'value-3' 'value-2' 'value-1')