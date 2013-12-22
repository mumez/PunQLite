testing
testExecuteAndGetString
	"self debug: #testExecuteAndGetString"
	| db executer src compiled executed result |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	src := '
	$var = 123;
	$str = "$var = $var";
	'.
		
	executer := db jx9.
	compiled := executer compile: src.
	self assert: compiled.
	
	executed := executer execute.
	self assert: executed.
	
	result := executer extract: 'var'.
	self assert: (result asInt = 123).
	
	result := executer extract: 'str'.
	self assert: (result asString = '123 = 123').
	
	
	