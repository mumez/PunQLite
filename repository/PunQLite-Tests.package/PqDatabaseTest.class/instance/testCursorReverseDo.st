testing
testCursorReverseDo
	"self debug: #testCursorReverseDo"
	| ok cursor entries |

	1 to: 10 do: [:idx |
		ok := self database 
			storeAt: idx asString 
			value: 'value-', idx asString.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	entries := OrderedCollection new.
	cursor reverseDo: [:cur |
		entries add: (cur currentStringKey -> cur currentStringValue)	].

	self assert: entries size equals: 10.
	self assert: (entries collect: #key) asArray reverse equals: #('1' '2' '3' '4' '5' '6' '7' '8' '9' '10').
	self assert: (entries collect: #value) asArray reverse equals: #('value-1' 'value-2' 'value-3' 'value-4' 'value-5' 'value-6' 'value-7' 'value-8' 'value-9' 'value-10').
	
	cursor close.
	self deny: cursor isOpen