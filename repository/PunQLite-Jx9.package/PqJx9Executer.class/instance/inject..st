actions
inject: aValueObject

	self compiled ifFalse: [	PqJx9Error signal: 'Script has not been compiled.' ].
	self executed ifTrue: [ PqJx9Error signal: 'Script has been executed.' ].	
	^ self isOk: (self ffi configVM: self handle addVar: aValueObject handle named: aValueObject name) 
