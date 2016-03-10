initialize-release
prepareHandle
	^ handle ifNil: [ handle := FFIExternalObject new ]