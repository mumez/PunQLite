testing
testCursorSeekUntilEndDo
	"self debug: #testCursorSeekUntilEndDo"
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
	cursor seek: '5' untilEndDo: [:cur |
		entries add: (cur currentStringKey -> cur currentStringValue)	
	].

	self assert: entries size = 6.
	self assert: ((entries collect: #key) asArray = #('5' '6' '7' '8' '9' '10')).
	self assert: ((entries collect: #value) asArray = #('value-5' 'value-6' 'value-7' 'value-8' 'value-9' 'value-10')).
	
	cursor close.
	self assert: cursor isOpen not.
	