testing
testCursorFetchString
	"self debug: #testCursorFetchString"
	| db ok cursor |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	1 to: 10 do: [:idx |
		ok := db storeAt: idx asString value: 'value-', idx asString.
		self assert: ok.
	].
	
	cursor := db newCursor.
	self assert: cursor isOpen.
	
	cursor first.
	self assert:  (cursor currentStringKey = '1').
	self assert:  (cursor currentStringValue = 'value-1').
	
	cursor next.
	self assert:  (cursor currentStringKey = '2').
	self assert:  (cursor currentStringValue = 'value-2').
	
	cursor last.
	self assert:  (cursor currentStringKey = '10').
	self assert:  (cursor currentStringValue = 'value-10').
	
	cursor previous.
	self assert:  (cursor currentStringKey = '9').
	self assert:  (cursor currentStringValue = 'value-9').
	
	cursor reset.
	self assert:  (cursor currentStringKey = '1').
	self assert:  (cursor currentStringValue = 'value-1').
	
	cursor close.
	self assert: cursor isOpen not.
	