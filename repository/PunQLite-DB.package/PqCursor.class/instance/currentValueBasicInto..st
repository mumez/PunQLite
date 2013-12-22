accessig value
currentValueBasicInto: aBlock
	| callback |
	callback := UnQLiteFetchCallback on: aBlock.
	^ ffi valueByCallback: callback on: self handle 