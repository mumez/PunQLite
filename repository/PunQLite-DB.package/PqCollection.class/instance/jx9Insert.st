private
jx9Insert
	^ executors 
		at: #jx9Insert 
		ifAbsentPut: [ self newJx9Executor: self class jx9InsertTemplate ]

	