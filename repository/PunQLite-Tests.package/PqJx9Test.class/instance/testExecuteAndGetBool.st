testing
testExecuteAndGetBool
	"self debug: #testExecuteAndGetBool"
	| db executer src compiled executed result |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	src := '
	$x = 10, $y = 20.5;
	$ret = $x < $y;
	'.
		
	executer := db jx9.
	compiled := executer compile: src.
	self assert: compiled.
	
	executed := executer execute.
	self assert: executed.
	
	result := executer @ 'x'.
	self assert: (result asInt = 10).
	
	result := executer @ 'y'.
	self assert: (result asDouble = 20.5).
	
	result := executer @ 'ret'.
	self assert: (result asBool).
	
	
	