closing
close
	self isOpen ifFalse: [ ^self ].
	(self isOk: (ffi close: self handle)) 
		ifTrue: [handleIsValid := false]