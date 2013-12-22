transactions
rollbackTransaction
	| ret |
	ret := ffi rollbackTransactionOn: self handle.
	^self isOk: ret