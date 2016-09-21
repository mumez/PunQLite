private
jx9SelectAll
	self flag: #todo. "Do not cache selectAll method for now (is not beeing re-executed, and 
	 I have no time to see why just now)"
	^ self newJx9Executor: self class jx9SelectAllTemplate.