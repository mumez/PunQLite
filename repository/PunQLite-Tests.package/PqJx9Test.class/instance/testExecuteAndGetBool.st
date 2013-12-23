testing
testExecuteAndGetBool
	"self debug: #testExecuteAndGetBool"
	| db src |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	src := '
	$x = 10, $y = 20.5;
	$ret = $x < $y;
	'.
		
	db jx9Do: [:executer | | compiled executed result |
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
	].
	db close.
	
	
	