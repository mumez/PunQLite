testing
testCursorRelease
	"self debug: #testCursorRelease"
	| db ok cursor |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	1 to: 10 do: [:idx |
		ok := db storeAt: idx asString value: 'value-', idx asString.
		self assert: ok.
	].
	
	cursor := db newCursor.
	self assert: cursor isOpen.
	cursor close.
	self assert: cursor isOpen not.
	