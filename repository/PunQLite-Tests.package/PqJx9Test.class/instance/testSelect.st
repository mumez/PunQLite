tests - collection
testSelect
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