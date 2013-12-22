testing
testCursorCurrentReverseDo
	"self debug: #testCursorCurrentReverseDo"
	| db ok cursor entries |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	1 to: 10 do: [:idx |
		ok := db storeAt: idx asString value: 'value-', idx asString.
		self assert: ok.
	].
	
	cursor := db newCursor.
	self assert: cursor isOpen.
	
	cursor seek: '5'.
	
	entries := OrderedCollection new.
	cursor fromCurrentReverseDo: [:cur |
		entries add: (cur currentStringKey -> cur currentStringValue)	
	].

	self assert: entries size = 5.
	self assert: ((entries collect: #key) asArray = #('5' '4' '3' '2' '1')).
	self assert: ((entries collect: #value) asArray = #('value-5' 'value-4' 'value-3' 'value-2' 'value-1')).
	
	cursor close.
	self assert: cursor isOpen not.
	