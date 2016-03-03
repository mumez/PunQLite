testing
testInjectJsonKeyValueExecuteGet
	"self debug: #testInjectStringExecuteGet"
	| db src data result |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	src := '
	if (db_exists("users")) {
	    db_drop_collection("users");
	}
	db_create("users");
	db_store("users", $inject); 
	$extract = db_fetch("users"); 
	'.
	
	db jx9Do: [ :executer | 
		| compiled injected released executed |
		compiled := executer compile: src.
		self assert: compiled.
	
		data := executer newStructure: 'inject'.
		data at: 'name' put: 'james'.
		data at: 'age' put: 27.	
	
		injected := executer inject: data.
		self assert: injected.
		
		released := executer release: data.
		self assert: released.
		
		executed := executer execute.
		self assert: executed.
		
		result := executer extract: 'extract'.
		self assert: result isJsonObject.
		
		released := executer release: result.
		self assert: released ].
	
	db close.
