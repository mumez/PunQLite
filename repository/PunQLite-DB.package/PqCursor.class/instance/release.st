initialize-release
release
	(self isOk: (self ffi releaseCursor: self handle db: self dbHandle )) 
		ifTrue: [handleIsValid := false].
	super release.
