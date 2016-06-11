accessing
add: aDictionary
	| data executor |
	executor := self jx9Insert.
	executor reset.
	data := executor newStructure: 'insert' json: aDictionary.
	self assert: (executor inject: data).
	executor execute.
	executor release: data.		
	self validateResultFrom: executor.
	^ aDictionary
