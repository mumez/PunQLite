testing
testExecuteThreePlusFour
	"self debug: #testExecuteThreePlusFour"
	| db src |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	src := '$var1 = 3+4;'.
	
	db jx9Do: [:executer | | compiled executed result |
		compiled := executer compile: src.
		self assert: compiled.
	
		executed := executer execute.
		self assert: executed.
	
		result := executer extract: 'var1'.
		self assert: (result asInt = 7).
	].
	db close
	
	