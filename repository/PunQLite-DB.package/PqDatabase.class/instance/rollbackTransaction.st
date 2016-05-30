transactions
rollbackTransaction
	| ret |
	ret := self ffi rollbackTransactionOn: self handle.
	^self isOk: ret