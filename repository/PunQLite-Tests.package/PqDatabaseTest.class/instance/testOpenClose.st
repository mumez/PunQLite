testing
testOpenClose
	"self debug: #testOpenClose"
	| db |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	db close.
	self assert: db isOpen not.
	