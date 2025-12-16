Class {
	#name : 'PqJx9Test',
	#superclass : 'TestCase',
	#category : 'PunQLite-Tests-Jx9',
	#package : 'PunQLite-Tests',
	#tag : 'Jx9'
}

{ #category : 'accessing' }
PqJx9Test class >> testRecords [
	^ { 
		{'name' -> 'John Doe'. 			'age' -> 44. 	'email' -> 'johndoe@mail.net'} asDictionary. 
		{'name' -> 'Jane Smith'. 		'age' -> 37. 	'email' -> 'jane.smith@mail.net'} asDictionary. 
		{'name' -> 'Jimmy Doe-Smith'. 	'age' -> 5. 		'email' -> nil} asDictionary. 
	}
]

{ #category : 'private' }
PqJx9Test >> addTestRecordsTo: db [
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
]

{ #category : 'private' }
PqJx9Test >> getAll: collectionName from: db [
	| records |
	db jx9Do: [ :executor | | result | 
		executor compile: ('$result = db_fetch_all("{1}")' format: { collectionName }).
		executor execute.
		result := executor extract: 'result'.
		records := result asArray ].
	^ records
]

{ #category : 'private' }
PqJx9Test >> getById: aNumber from: db [
	| records |
	
	db jx9Do: [ :executor | | result |
		executor compile: '$result = db_fetch_all("users", query)'.
		executor newFunction: 'query' do: [ :rec | (rec at: '__id') = aNumber ].
		executor execute.
		result := executor extract: 'result'.
		result isJsonArray 
			ifTrue: [ records := result asArray ]
			ifFalse: [ ^ nil ] ].
		
	^ records first
		
]

{ #category : 'tests' }
PqJx9Test >> testExecuteAndGetBool [
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
	
	
	
]

{ #category : 'tests' }
PqJx9Test >> testExecuteAndGetInt64 [
	"self debug: #testExecuteAndGetInt64"
	| db src |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	src := '
	$var = 2147483647;
	$var = $var + 1;
	'.
	
	db jx9Do: [:executer | | compiled executed result |
		compiled := executer compile: src.
		self assert: compiled.
	
		executed := executer execute.
		self assert: executed.
	
		result := executer extract: 'var'.
		self assert: (result asInt = -2147483648).
	
		result := executer extract: 'var'.
		self assert: (result asInt64 = 2147483648).
	].
	db close.
	
	
	
]

{ #category : 'tests' }
PqJx9Test >> testExecuteAndGetString [
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
	
	
	
]

{ #category : 'tests' }
PqJx9Test >> testExecuteThreePlusFour [
	"self debug: #testExecuteThreePlusFour"
	| db src |
	db := PqDatabase openOnMemory.
	self assert: db isOpen.
	
	src := '$var1 = 3+4;'.
	
	db jx9Do: [:executer | | compiled executed result |
		compiled := executer compile: src.
		self assert: compiled.
	
		executed := executer execute.
		self assert: executed.
	
		result := executer extract: 'var1'.
		self assert: (result asInt = 7).
	].
	db close
	
	
]

{ #category : 'tests' }
PqJx9Test >> testInjectJsonKeyValueExecuteGet [
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
	$extract = db_fetch_all("users"); 
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
		self assert: result isJsonArray.
		self assert: (result elementCount = 1).
		
		released := executer release: result.
		self assert: released ].
	
	db close.

]

{ #category : 'tests - collection' }
PqJx9Test >> testInsert [
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
]

{ #category : 'tests - collection' }
PqJx9Test >> testInsertJSON [
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
]

{ #category : 'tests - collection' }
PqJx9Test >> testInsertReentrant [
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
]

{ #category : 'tests - collection' }
PqJx9Test >> testRemove [
	| db records |
		
	db := PqDatabase openOnMemory.
	self addTestRecordsTo: db.

	db jx9Do: [ :executor | | id result |
		executor compile: '$result = db_drop_record("users", $id)'.
		id := (2 jx9ValueOn: executor) name: 'id'.
		executor inject: id.
		executor execute.
		result := executor extract: 'result'.
		self assert: result asBool.
		self assert: (executor release: id) ].

	records := self getAll: 'users' from: db. 
	self assert: records size equals: 2.
	self class testRecords allButLast 
		withIndexDo: [ :each :index | | record |
			record := records at: index.
			record removeKey: '__id'.
			self assert: record equals: each ]
]

{ #category : 'tests - collection' }
PqJx9Test >> testSelect [
	<script>
	| db records |
		
	db := PqDatabase openOnMemory.
	self addTestRecordsTo: db.

	db jx9Do: [ :executor | | result |
		executor compile: '$result = db_fetch_all("users", query)'.
		executor newFunction: 'query' do: [ :rec | (rec at: '__id') = 1 ].
		executor execute.
		result := executor extract: 'result'.
		result isJsonArray 
			ifTrue: [ records := result asArray ] ].

	self assert: records size equals: 1.
	records first removeKey: '__id'.
	
	"id == 1 is the second register (because ids are asigned starting from zero)"
	self 
		assert: records first 
		equals: self class testRecords second
]

{ #category : 'tests - collection' }
PqJx9Test >> testSelectAll [
	<script>
	| db records |
		
	db := PqDatabase openOnMemory.
	self addTestRecordsTo: db.

	db jx9Do: [ :executor | | result |
		executor compile: '$result = db_fetch_all("users")'.
		executor execute.
		result := executor extract: 'result'.
		result isJsonArray 
			ifTrue: [ records := result asArray ] ].

	self assert: records size equals: 3.
	self class testRecords withIndexDo: [ :each :index | | record |
		record := records at: index.
		record removeKey: '__id'.
		self assert: record equals: each ]
]

{ #category : 'tests - collection' }
PqJx9Test >> testUpdate [
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
]
