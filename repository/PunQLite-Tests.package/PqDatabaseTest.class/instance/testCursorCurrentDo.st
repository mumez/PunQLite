testing
testCursorCurrentDo
	"self debug: #testCursorCurrentDo"
	| ok cursor entries |
	
	1 to: 10 do: [:index |
		ok := self database 
			storeAt: index asString 
			value: 'value-', index asString.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	cursor seek: '5'.	
	entries := OrderedCollection new.
	cursor fromCurrentDo: [ :theCursor |
		entries add: (theCursor currentStringKey -> theCursor currentStringValue) ].

	self assert: entries size equals: 6.
	self assert: (entries collect: #key) asArray equals: #('5' '6' '7' '8' '9' '10').
	self assert: (entries collect: #value) asArray equals: #('value-5' 'value-6' 'value-7' 'value-8' 'value-9' 'value-10')