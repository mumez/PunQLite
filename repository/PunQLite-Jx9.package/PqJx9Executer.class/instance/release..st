actions
release: aValueObject
	^ self isOk: (ffi releaseValue: aValueObject handle vm: self handle)