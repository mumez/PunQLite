transactions
beginTransaction
	| ret |
	ret := self ffi beginTransactionOn: self handle.
	^self isOk: ret