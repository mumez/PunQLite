tests - collection
testInsertReentrant
	<script>
		
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
		data at: 'name' put: 'paola'.
		data at: 'age' put: 37.
		data at: 'email' put: 'sedda.paola@gmail.com'.
		self assert: (executor inject: data).		
		executor execute.
		self assert: (executor release: data).
		result := executor extract: 'result'.
		self assert: result asBool.
		
		executor reset.

		data := executor newStructure: 'insert'.
		data at: 'name' put: 'adem'.
		data at: 'age' put: 5.
		data at: 'email' put: nil.
		self assert: (executor inject: data).		
		executor execute.
		self assert: (executor release: data).
		result := executor extract: 'result'.
		self assert: result asBool ].