accessing key
currentKeyByBasicInto: aBlock userData: userData
	| callback |
	callback := UnQLiteFetchCallback on: aBlock.
	^ ffi keyByCallback: callback userData: userData on: self handle 