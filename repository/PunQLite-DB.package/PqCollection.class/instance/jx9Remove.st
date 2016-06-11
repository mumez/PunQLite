private
jx9Remove
	^ executors 
		at: #jx9Remove 
		ifAbsentPut: [ self newJx9Executor: self class jx9RemoveTemplate ]

	