tests
testExecuteAndGetInt64
	"self debug: #testExecuteAndGetInt64"
	| db src |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	src := '
	$var = 2147483647;
	$var = $var + 1;
	'.
	
	db jx9Do: [:executer | | compiled executed result |
		compiled := executer compile: src.
		self assert: compiled.
	
		executed := executer execute.
		self assert: executed.
	
		result := executer extract: 'var'.
		self assert: (result asInt = -2147483648).
	
		result := executer extract: 'var'.
		self assert: (result asInt64 = 2147483648).
	].
	db close.
	
	
	