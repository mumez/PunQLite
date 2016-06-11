enumerating
asDictionary
	| newDictionary |
	newDictionary := Dictionary new.
	self keysAndValuesDo: [ :key :value | 
		newDictionary at: key asString put: value value ].
	^ newDictionary