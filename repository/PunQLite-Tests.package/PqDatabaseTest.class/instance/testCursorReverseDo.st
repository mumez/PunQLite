testing
testCursorReverseDo
	"self debug: #testCursorReverseDo"
	| db ok cursor entries |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	1 to: 10 do: [:idx |
		ok := db storeAt: idx asString value: 'value-', idx asString.
		self assert: ok.
	].
	
	cursor := db newCursor.
	self assert: cursor isOpen.
	
	entries := OrderedCollection new.
	cursor reverseDo: [:cur |
		entries add: (cur currentStringKey -> cur currentStringValue)	
	].

	self assert: entries size = 10.
	self assert: ((entries collect: #key) asArray reverse = #('1' '2' '3' '4' '5' '6' '7' '8' '9' '10')).
	self assert: ((entries collect: #value) asArray reverse = #('value-1' 'value-2' 'value-3' 'value-4' 'value-5' 'value-6' 'value-7' 'value-8' 'value-9' 'value-10')).
	
	cursor close.
	self assert: cursor isOpen not.
	