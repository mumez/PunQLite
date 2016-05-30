accessing key
currentKeyBasicInto: aBlock
	| callback |
	callback := UnQLiteFetchCallback on: aBlock.
	^ self ffi 
		keyByCallback: callback 
		on: self handle 