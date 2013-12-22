transactions
beginTransaction
	| ret |
	ret := ffi beginTransactionOn: self handle.
	^self isOk: ret