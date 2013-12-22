accessing
fetchBufferSize
	^ fetchBufferSize ifNil: [fetchBufferSize := self database fetchBufferSize]