initialize-release
close
	self isOpen ifFalse: [ ^self ].
	self release