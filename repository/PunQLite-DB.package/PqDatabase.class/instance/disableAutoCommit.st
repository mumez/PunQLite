configuration
disableAutoCommit
	| ret |
	ret := ffi config: self handle command:  UnQLiteConstants CONFIG_DISABLE_AUTO_COMMIT.
	^self isOk: ret