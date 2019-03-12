"
I'm a collection in a PunQLite database. 
I handle ==documents==, defined as JSON entries. 

While I try to keep a common API with a Collection, I'm not exactly one, in particular my elements need to be JSON dictionaries, not any arbitrary object.

"
Class {
	#name : #PqCollection,
	#superclass : #Object,
	#instVars : [
		'name',
		'database',
		'executors'
	],
	#category : 'PunQLite-DB-Base'
}

{ #category : #'instance creation' }
PqCollection class >> database: aDatabase name: aString [
	^ self basicNew 
		initializeDatabase: aDatabase name: aString;
		yourself
]

{ #category : #'private templates' }
PqCollection class >> jx9AtPutTemplate [
	^ '
$result = db_update_record("{name}", $id, $record);
if (!$result) \{ 
	$errorMessage = db_errlog(); 
}'
]

{ #category : #'private templates' }
PqCollection class >> jx9AtTemplate [
	^ '$record = db_fetch_by_id("{name}", $id)'
]

{ #category : #'private templates' }
PqCollection class >> jx9CreateTemplate [
	^ '
$result = 1;
if(!db_exists("{name}")) \{
	$result = db_create("{name}");
	if (!$result) \{ 
		$errorMessage = db_errlog(); 
	}	
}
'
]

{ #category : #'private templates' }
PqCollection class >> jx9InsertTemplate [
	^ '
$result = db_store("{name}", $insert);
if ($result) \{ 
	$resultId = db_last_record_id("{name}");
} else \{ 
	$errorMessage = db_errlog(); 
}'
]

{ #category : #'private templates' }
PqCollection class >> jx9RemoveTemplate [
	^ '
$result = db_drop_record("{name}", $id);
if (!$result) \{ 
	$errorMessage = db_errlog(); 
}'
]

{ #category : #'private templates' }
PqCollection class >> jx9SelectAllTemplate [
	^ '$records = db_fetch_all("{name}")'
]

{ #category : #'private templates' }
PqCollection class >> jx9SelectTemplate [
	^ '$records = db_fetch_all("{name}", filter)'
]

{ #category : #'private templates' }
PqCollection class >> jx9SizeOfTemplate [
	^ '$numberOfRecords = count(db_fetch_all("{name}", filter))'
]

{ #category : #'private templates' }
PqCollection class >> jx9SizeTemplate [
	^ '$result = db_total_records("{name}")'
]

{ #category : #'instance creation' }
PqCollection class >> new [
	self error: 'Use #database:name:'
]

{ #category : #accessing }
PqCollection >> add: jsonDictionary [
	"Adds a JSON dictionary to collection. 
	 Answers the id of the record inserted"
	| data executor |
	
	executor := self jx9Insert.
	executor reset.
	data := executor newStructure: 'insert' json: jsonDictionary.
	self assert: (executor inject: data).
	executor execute.
	executor release: data.		
	self validateResultFrom: executor.
	^ (executor extract: 'resultId') value

]

{ #category : #accessing }
PqCollection >> at: anId [
	"retrieves a documents with id or nil if not found"
	| executor id |
	
	executor := self jx9At.
	executor reset.
	id := (anId jx9ValueOn: executor) name: 'id'.
	executor inject: id.
	executor execute.
	executor release: id.	
	^ (executor extract: 'record') value
]

{ #category : #accessing }
PqCollection >> at: anId put: jsonDictionary [
	"Replaces the contents of document id 'anId' with new contents"
	| executor data id |

	executor := self jx9AtPut.
	executor reset.
	id := (anId jx9ValueOn: executor) name: 'id'.
	executor inject: id.
	data := executor newStructure: 'record' json: jsonDictionary.
	executor inject: data.
	executor execute.
	self validateResultFrom: executor.
	
]

{ #category : #private }
PqCollection >> database [
	^ database
]

{ #category : #enumerating }
PqCollection >> detect: aBlock [
	"Answer first document that matches aBlock.
	 NOTE: Since unqlite does not have a 'detect' function, we need to simulate like this... 
	 which is not the best, but works"
	^ (self select: aBlock) 
		ifNotEmpty: [ :result | result first ]
		ifEmpty: [ nil ]
]

{ #category : #private }
PqCollection >> ensureCollection [
	| executor |
	executor := self jx9Create.
	executor reset.
	executor execute.
	self validateResultFrom: executor
]

{ #category : #initialization }
PqCollection >> initialize [
	super initialize.
	executors := Dictionary new.
	self ensureCollection
]

{ #category : #initialization }
PqCollection >> initializeDatabase: aDatabase name: aString [
	database := aDatabase.
	name := aString.
	self initialize
]

{ #category : #private }
PqCollection >> jx9At [
	^ executors 
		at: #jx9At 
		ifAbsentPut: [ self newJx9Executor: self class jx9AtTemplate ]
]

{ #category : #private }
PqCollection >> jx9AtPut [
	^ executors 
		at: #jx9AtPut 
		ifAbsentPut: [ self newJx9Executor: self class jx9AtPutTemplate ]
]

{ #category : #private }
PqCollection >> jx9Create [
	^ executors 
		at: #jx9Create 
		ifAbsentPut: [ self newJx9Executor: self class jx9CreateTemplate ]
]

{ #category : #private }
PqCollection >> jx9Insert [
	^ executors 
		at: #jx9Insert 
		ifAbsentPut: [ self newJx9Executor: self class jx9InsertTemplate ]

	
]

{ #category : #private }
PqCollection >> jx9Remove [
	^ executors 
		at: #jx9Remove 
		ifAbsentPut: [ self newJx9Executor: self class jx9RemoveTemplate ]

	
]

{ #category : #private }
PqCollection >> jx9Select [
	"select executor is not cached (see #select: method for an explanation)"
	^ self newJx9Executor: self class jx9SelectTemplate
]

{ #category : #private }
PqCollection >> jx9SelectAll [
	self flag: #todo. "Do not cache selectAll method for now (is not beeing re-executed, and 
	 I have no time to see why just now)"
	^ self newJx9Executor: self class jx9SelectAllTemplate.
]

{ #category : #private }
PqCollection >> jx9Size [
	"Do not cache size executor... see #size method for an explanation."
	^ self newJx9Executor: self class jx9SizeTemplate
]

{ #category : #private }
PqCollection >> jx9SizeOf [
	"Do not cache size executor... see #size method for an explanation."
	^ self newJx9Executor: self class jx9SizeOfTemplate
]

{ #category : #accessing }
PqCollection >> name [
	^ name
]

{ #category : #private }
PqCollection >> newJx9Executor: aString [ 
	| jx9Executor |
	
	jx9Executor := self database jx9.
	jx9Executor compile: (aString format: { #name -> self name } asDictionary).
	^ jx9Executor
]

{ #category : #accessing }
PqCollection >> removeAt: anId [
	"Removes the document with id 'anId'"
	| executor id |
	
	executor := self jx9Remove.
	executor reset.
	id := (anId jx9ValueOn: executor) name: 'id'.
	executor inject: id.
	executor execute.
	executor release: id.
	self validateResultFrom: executor
]

{ #category : #enumerating }
PqCollection >> select: aBlock [
	"Answer all documents that matches aBlock
	 NOTE: Since I have a potential different select each time, I need to create a different 
	 executor. This is probably a very naive approach, but is the easiest I have for now :) "
	| executor |
	executor := self jx9Select.
	[
		executor newFunction: 'filter' do: aBlock.
		executor execute.
		^ (executor extract: 'records') asArray ]
	ensure: [ executor release ]
]

{ #category : #enumerating }
PqCollection >> selectAll [
	"Answer all documents in a collection"
	| executor |
	executor := self jx9SelectAll.
	executor reset.
	executor execute.
	^ (executor extract: 'records') asArray
]

{ #category : #accessing }
PqCollection >> size [
	"Answer the size of current collection (# of records)"
	| executor |
	
	self flag: #fixMe. "For some reason, caching the executor for gettings records is 
	 not working (it answers always first value, even if size changes. 
	 So for now I'm not caching it..."
	executor := self jx9Size.
	[ 
		executor execute.
		^ (executor extract: 'result') value ]
	ensure: [ executor release ]
]

{ #category : #accessing }
PqCollection >> sizeOf: aBlock [
	"Answer all documents that matches aBlock
	 NOTE: Since I have a potential different select each time, I need to create a different 
	 executor. This is probably a very naive approach, but is the easiest I have for now :) "
	| executor |
	executor := self jx9SizeOf.
	[
		executor newFunction: 'filter' do: aBlock.
		executor execute.
		^ (executor extract: 'numberOfRecords') value ]
	ensure: [ executor release ]
]

{ #category : #private }
PqCollection >> validateResultFrom: anExecutor [
	(anExecutor extract: 'result') asBool 
		ifFalse: [ PqCollectionError signal: (anExecutor extract: 'errorMessage') asString ]	

]
