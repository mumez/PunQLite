utilities
getRandomStringSized: size
	| ourStr |
	ourStr := (ExternalAddress fromString: (String new: size)) autoRelease.
	self ffi getRandomString: self handle into: ourStr sized: size.
	^ ourStr readString.