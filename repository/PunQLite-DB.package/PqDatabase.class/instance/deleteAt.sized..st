actions
deleteAt: key sized: keySize
	| ret |
	ret := self ffi 
		delete: self handle 
		key: key 
		sized: keySize.
	^self isOk: ret