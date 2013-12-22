accessing
fetchBufferSize
	^ fetchBufferSize ifNil: [fetchBufferSize := self settings defaultFetchBufferSize]