testing
testKeys
	"self debug: #testKeys"
	| db ok  |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	1 to: 10 do: [:idx |
		ok := db storeAt: idx asString value: 'value-', idx asString.
		self assert: ok.
	].
	
	self assert: db size = 10.
	
	self assert: (db keys =  #('1' '2' '3' '4' '5' '6' '7' '8' '9' '10')).
	
	db close.
	self assert: db isOpen not.
	