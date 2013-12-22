transactions
commitTransaction
	| ret |
	ret := ffi commitTransactionOn: self handle.
	^self isOk: ret