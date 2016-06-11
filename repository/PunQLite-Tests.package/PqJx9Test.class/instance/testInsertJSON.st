tests - collection
testInsertJSON
	| db json records retrieveJson |
	
	db := PqDatabase openOnMemory.

	db jx9Do: [ :executor | | data result |
		executor compile: '
			if (!db_exists("test")) {
			   $result = db_create("test");
				if (!$result) { 
					$errorMessage = db_errlog(); 
					return; 
				}
			};
			$result = db_store("test", $insert);
			if (!$result) { 
				$errorMessage = db_errlog(); 
			}'.
	
		json := {
			'string' -> 'testing'.
			'integer' -> 42.
			'float' -> 42.0.
			'boolean' -> true.
			'nil' -> nil.
			'dictionary1' -> { 'key1' -> 'A key'. 'key2' -> 42 } asDictionary.
			'dictionary2' -> { 'key1' -> #(1 2 3). 'key2' -> {1. 'hello'. true. 42.0 } } asDictionary.
			'array1' -> #(1 2 3).
			'array2' -> {1. 'hello'. true. 42.0 }.
			'array3' -> self class testRecords. "array of dicts"
		} asDictionary.
		
		data := executor newStructure: 'insert' json: json.
		self assert: (executor inject: data).
		executor execute.
		result := executor extract: 'result'.
		self assert: result asBool.
		self assert: (executor release: data) ].
	
	records := self getAll: 'test' from: db.
	self assert: records size equals: 1.
	retrieveJson := records first.
	retrieveJson removeKey: '__id'.
	self assert: retrieveJson equals: json
	
