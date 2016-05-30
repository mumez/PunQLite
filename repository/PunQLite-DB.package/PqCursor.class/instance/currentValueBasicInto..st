accessig value
currentValueBasicInto: aBlock
	| callback |
	callback := UnQLiteFetchCallback on: aBlock.
	^ self ffi 
		valueByCallback: callback 
		on: self handle 