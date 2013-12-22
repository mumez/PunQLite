testing
testStoreFetchByCallback
	"self debug: #testStoreFetchByCallback"
	| db ok fetched |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	ok := db storeAt: 'Smalltalk' value: 'COOL'.
	self assert: ok.
	
	db fetchAt: 'Smalltalk' basicInto: [:dataAddr :dataSize :userData |
		| data |
		self assert: (dataSize = 'COOL' size).
		data := ByteArray new: dataSize.
		NativeBoost memCopy: dataAddr to: data size: dataSize.
		self assert: (data asString = 'COOL' ).
		0
	].
	
	db fetchAt: 'Smalltalk' into: [:data |
		fetched := data asString.
	].
	self assert: (fetched = 'COOL').
	
	db close.
	self assert: db isOpen not.
	