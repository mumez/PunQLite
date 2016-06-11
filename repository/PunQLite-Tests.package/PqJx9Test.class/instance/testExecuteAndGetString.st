tests
testExecuteAndGetString
	"self debug: #testExecuteAndGetString"
	| db src |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	src := '
	$var = 123;
	$str = "$var = $var";
	'.
	
	db jx9Do: [:executer | | compiled executed result |
		compiled := executer compile: src.
		self assert: compiled.
	
		executed := executer execute.
		self assert: executed.
	
		result := executer extract: 'var'.
		self assert: (result asInt = 123).
	
		result := executer extract: 'str'.
		self assert: (result asString = '123 = 123').
	].
	db close.
	
	
	