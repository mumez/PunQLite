actions
appendAt: key value: value
	| ret |
	ret := ffi append: self handle key: key sized: key size value: value sized: value size.
	^self isOk: ret