tests - collection
testSelectAll
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