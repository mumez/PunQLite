private
jx9SelectAll
	^ executors 
		at: #jx9SelectAll 
		ifAbsentPut: [ self newJx9Executor: self class jx9SelectAllTemplate ].