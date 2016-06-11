private
addTestRecordsTo: db
	db jx9Do: [ :executor | | data |
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
		
		self class testRecords do: [ :each | | result |
			data := executor newStructure: 'insert' json: each.
			executor inject: data.
			executor execute.
			result := executor extract: 'result'.
			result asBool ifFalse: [ 
				self error: (executor extract: 'errorMessage') asString ].
			executor release: data.
			executor reset ] ]