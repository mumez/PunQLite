testing
testCursorSeek
	"self debug: #testCursorSeek"
	| db ok cursor  |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	1 to: 10 do: [:idx |
		ok := db storeAt: idx asString value: 'value-', idx asString.
		self assert: ok.
	].
	
	cursor := db newCursor.
	self assert: cursor isOpen.
	
	cursor seek: '5'.
	self assert:  (cursor currentStringValue = 'value-5').

	cursor seek: '10'.
	self assert:  (cursor currentStringValue = 'value-10').
	
	cursor seek: '3'.
	self assert:  (cursor currentStringValue = 'value-3').
	
	self deny:  (cursor seek: '100').
	
	cursor close.
	self assert: cursor isOpen not.
	