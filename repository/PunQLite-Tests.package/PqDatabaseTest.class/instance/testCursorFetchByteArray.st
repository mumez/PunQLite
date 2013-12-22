testing
testCursorFetchByteArray
	"self debug: #testCursorFetchByteArray"
	| db ok cursor |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	1 to: 10 do: [:idx |
		ok := db storeAt: (ByteArray with: idx) value: ('value-', idx asString) asByteArray.
		self assert: ok.
	].
	
	cursor := db newCursor.
	self assert: cursor isOpen.
	
	cursor first.
	self assert:  (cursor currentKey = #[1]).
	self assert:  (cursor currentValue = 'value-1' asByteArray).
	
	cursor next.
	self assert:  (cursor currentKey = #[2]).
	self assert:  (cursor currentValue = 'value-2' asByteArray ).
	
	cursor last.
	self assert:  (cursor currentKey = #[10]).
	self assert:  (cursor currentValue = 'value-10' asByteArray).
	
	cursor previous.
	self assert:  (cursor currentKey = #[9]).
	self assert:  (cursor currentValue = 'value-9' asByteArray).
	
	cursor reset.
	self assert:  (cursor currentKey = #[1]).
	self assert:  (cursor currentValue = 'value-1' asByteArray).
	
	cursor close.
	self assert: cursor isOpen not.
	