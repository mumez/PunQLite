testing
testExecuteThreePlusFour
	"self debug: #testExecuteThreePlusFour"
	| db executer src compiled executed result |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	src := '$var1 = 3+4;'.
	executer := db jx9.
	compiled := executer compile: src.
	self assert: compiled.
	
	executed := executer execute.
	self assert: executed.
	
	result := executer extract: 'var1'.
	
	self assert: (result asInt = 7).
	
	
	
	