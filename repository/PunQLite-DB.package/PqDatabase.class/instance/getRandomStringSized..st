utilities
getRandomStringSized: size
	| ourStr |
	ourStr := NBExternalAddress fromString: (String new: size).
	ffi getRandomString: self handle into: ourStr sized: size.
	^ ourStr readString.