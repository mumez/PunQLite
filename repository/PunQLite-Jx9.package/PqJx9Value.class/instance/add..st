accessing
add: aValue
	^ self ffi structure: self handle atPosition: ExternalAddress null putValue: aValue handle