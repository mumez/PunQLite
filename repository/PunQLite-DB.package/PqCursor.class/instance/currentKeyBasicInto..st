accessing key
currentKeyBasicInto: aBlock
	| callback |
	callback := UnQLiteFetchCallback on: aBlock.
	^ ffi keyByCallback: callback on: self handle 