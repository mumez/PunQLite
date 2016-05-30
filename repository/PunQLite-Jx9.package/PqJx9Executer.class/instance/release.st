initailize-release
release
	self isValid ifFalse: [ ^self ].
	(self isOk: (self ffi releaseVm: self handle)) 
		ifTrue: [handleIsValid := false].
	super release.