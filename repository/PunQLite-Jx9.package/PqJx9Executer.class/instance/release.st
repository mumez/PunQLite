initailize-release
release
	self isValid ifFalse: [ ^self ].
	(self isOk: (ffi releaseVm: self handle)) 
		ifTrue: [handleIsValid := false].
	super release.