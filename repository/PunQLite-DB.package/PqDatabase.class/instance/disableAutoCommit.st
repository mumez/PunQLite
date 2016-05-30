configuration
disableAutoCommit
	| ret |
	ret := self ffi 
		config: self handle 
		command: CONFIG_DISABLE_AUTO_COMMIT.
	^self isOk: ret