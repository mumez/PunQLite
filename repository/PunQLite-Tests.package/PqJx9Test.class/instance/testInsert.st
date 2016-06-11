tests - collection
testInsert
	"db := PqDatabase openOnMemory."
	| db |
	
	db := PqDatabase openOnMemory.

	db jx9Do: [ :executor | | data result |
		executor compile: '
			if (!db_exists("users")) {
			   $result = db_create("users");
				if (!$result) { 
					$errorMessage = db_errlog(); 
					return; 
				}
			};
			$result = db_store("users", $insert);
			if (!$result) { 
				$errorMessage = db_errlog(); 
			}'.
		
		data := executor newStructure: 'insert'.
		data at: 'name' put: 'esteban'.
		data at: 'age' put: 44.
		data at: 'email' put: 'estebanlm@gmail.com'.
		self assert: (executor inject: data).
		
		executor execute.
		result := executor extract: 'result'.
		result asBool 
			ifFalse: [ self error: (executor extract: 'errorMessage') asString ].
		self assert: (executor release: data) ]