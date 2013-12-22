testing
testCursorFetchByteArrayByCallback
	"self debug: #testCursorFetchByteArrayByCallback"
	| db ok cursor val |
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
	cursor currentValueInto: [:data | val := data].
	self assert:  (val = 'value-1' asByteArray).
	
	cursor next.
	self assert:  (cursor currentKey = #[2]).
	cursor currentValueInto: [:data | val := data].
	self assert:  (val = 'value-2' asByteArray ).
	
	cursor last.
	self assert:  (cursor currentKey = #[10]).
	cursor currentValueInto: [:data | val := data].
	self assert:  (val = 'value-10' asByteArray).
	
	cursor close.
	self assert: cursor isOpen not.
	