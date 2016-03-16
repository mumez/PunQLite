testing
testCursorSeekUntilBeginDo
	"self debug: #testCursorSeekUntilBeginDo"
	| ok cursor entries |
	
	1 to: 10 do: [ :index |
		ok := self database 
			storeAt: index asString 
			value: 'value-', index asString.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	entries := OrderedCollection new.
	cursor seek: '5' untilBeginDo: [ :theCursor |
		entries add: (theCursor currentStringKey -> theCursor currentStringValue)	].

	self assert: entries size equals: 5.
	self assert: (entries collect: #key) asArray equals: #('5' '4' '3' '2' '1').
	self assert: (entries collect: #value) asArray equals: #('value-5' 'value-4' 'value-3' 'value-2' 'value-1').
	
	cursor close.
	self deny: cursor isOpen