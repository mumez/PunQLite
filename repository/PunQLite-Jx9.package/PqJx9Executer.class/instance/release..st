actions
release: aValueObject
	^ self isOk: (self ffi releaseValue: aValueObject handle vm: self handle)