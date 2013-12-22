actions
fetchAt: key basicInto: aBlock
	| callback |
	callback := UnQLiteFetchCallback on: aBlock.
	^ffi fetch: self handle key: key sized: key size callback: callback. 