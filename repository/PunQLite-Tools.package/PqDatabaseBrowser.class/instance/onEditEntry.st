private - actions
onEditEntry
	|key value |
	self database ifNil: [ ^self ].
	
	key := self keysModel selectedItem.
	key ifNil: [ ^self ].
	
	value := UIManager default request: 'New value for ', key initialAnswer: (database at: key).
	value ifNil: [ ^self ].
	
	self database notNil ifTrue: [
		self database transact: [
			self database at: key put: value.
		].
		self updateValueModel ]