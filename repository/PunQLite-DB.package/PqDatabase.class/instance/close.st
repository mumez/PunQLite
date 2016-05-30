closing
close
	self isOpen ifFalse: [ ^self ].
	(self isOk: (self ffi close: self handle)) 
		ifTrue: [handleIsValid := false]