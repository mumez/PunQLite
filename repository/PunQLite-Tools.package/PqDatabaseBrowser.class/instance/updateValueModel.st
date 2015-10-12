private - updating
updateValueModel

	|key|
	key := self keysModel selectedItem.
	key 
		ifNil: [ self valueModel text: '' ] 
		ifNotNil: [ self valueModel text: (self database at: key) asString ]