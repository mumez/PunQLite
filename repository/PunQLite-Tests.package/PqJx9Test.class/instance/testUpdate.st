tests - collection
testUpdate
	| db json retrieveJson |
	
	db := PqDatabase openOnMemory.
	self addTestRecordsTo: db.

	db jx9Do: [ :executor | | id data result |
		self assert: (executor compile: '
			$result = db_update_record("users", $id, $update);
			if (!$result) { 
				$errorMessage = db_errlog(); 
			}').
		
		id := (executor newScalarInteger64: 0) name: 'id'.
		self assert: (executor inject: id).
		
		json := { 'name' -> 'Nobody Knows'. 'age' -> nil. 'email' -> nil } asDictionary.
		data := executor newStructure: 'update' json: json.
		self assert: (executor inject: data).
		
		executor execute.
		result := executor extract: 'result'.
		result asBool ifFalse: [ 
			self error: (executor extract: 'errorMessage') asString ].
		self assert: (executor release: id).
		self assert: (executor release: data) ].
	
	retrieveJson := self getById: 0 from: db.
	retrieveJson removeKey: '__id'.
	self assert: retrieveJson equals: json