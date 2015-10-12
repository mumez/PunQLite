private - actions
onRemoveSelectedEntry

	self database notNil ifTrue: [
		self database transact: [
			self database removeKey: self keysModel selectedItem.
			self keysModel resetSelection ].
		self updateKeysModel ]