actions
execute
	| ret |
	self compiled ifFalse: [^false].
	self executed ifTrue: [(self reset) ifFalse: [^false]].
	
	ret := self ffi executeOn: self handle.
	(self isOk: ret) ifTrue: [executed := true].
	^executed