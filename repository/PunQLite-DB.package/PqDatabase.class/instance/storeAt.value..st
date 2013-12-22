actions
storeAt: key value: value
	| ret |
	ret := ffi store: self handle key: key sized: key size value: value sized: value size.
	^self isOk: ret