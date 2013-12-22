testing
testValues
	"self debug: #testValues"
	| db ok values |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	1 to: 10 do: [:idx |
		ok := db storeAt: idx asString value: 'value-', idx asString.
		self assert: ok.
	].
	
	self assert: db size = 10.
	
	values := db values collect: [:each | each asString].
	self assert: (values =  #('value-1' 'value-2' 'value-3' 'value-4' 'value-5' 'value-6' 'value-7' 'value-8' 'value-9' 'value-10')).
	
	db close.
	self assert: db isOpen not.
	