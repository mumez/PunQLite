opening
open: filePath mode: mode
	self isOpen ifTrue: [ ^self ].
	handleIsValid := self isOk: (self ffi 
		open: self prepareHandle 
		named: filePath 
		mode: mode)