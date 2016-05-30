transactions
commitTransaction
	| ret |
	ret := self ffi commitTransactionOn: self handle.
	^self isOk: ret