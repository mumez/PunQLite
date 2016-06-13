accessing
add: jsonDictionary
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
