accessing
add: jsonDictionary
	"Adds a JSON dictionary to collection"
	| data executor |
	
	executor := self jx9Insert.
	executor reset.
	data := executor newStructure: 'insert' json: jsonDictionary.
	self assert: (executor inject: data).
	executor execute.
	executor release: data.		
	self validateResultFrom: executor.
	^ jsonDictionary
