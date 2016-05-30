initialize-release
prepareHandle
	^ handle ifNil: [ handle := ExternalAddress new ]