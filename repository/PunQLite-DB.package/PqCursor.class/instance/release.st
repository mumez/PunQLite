initialize-release
release
	(self isOk: (ffi releaseCursor: self handle db: self dbHandle )) 
		ifTrue: [handleIsValid := false].
	super release.
