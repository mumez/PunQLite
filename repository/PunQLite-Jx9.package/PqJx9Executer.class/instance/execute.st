actions
execute
	| ret |
	self compiled ifFalse: [^false].
	self executed ifTrue: [(self reset) ifFalse: [^false]].
	
	ret := ffi executeOn: self handle.
	(self isOk: ret) ifTrue: [executed := true].
	^executed