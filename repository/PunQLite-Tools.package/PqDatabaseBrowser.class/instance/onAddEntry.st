private - actions
onAddEntry
	|key value |
	self database ifNil: [ ^self ].
	
	key := UIManager default request: 'New key' initialAnswer: ''.
	key ifNil: [ ^self ]. 

	value := UIManager default request: 'New value' initialAnswer: ''.
	value ifNil: [ ^self ].
	
	self database notNil ifTrue: [
		self database transact: [
			self database at: key put: value.
		].
		self updateKeysModel ]