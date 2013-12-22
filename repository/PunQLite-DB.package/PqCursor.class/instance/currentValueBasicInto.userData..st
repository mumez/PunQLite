accessig value
currentValueBasicInto: aBlock userData: userData
	| callback |
	callback := UnQLiteFetchCallback on: aBlock.
	^ ffi valueByCallback: callback userData: userData on: self handle 