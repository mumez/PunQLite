tests - collection
testRemove
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