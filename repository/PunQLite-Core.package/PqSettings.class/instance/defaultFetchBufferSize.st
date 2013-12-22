accessing
defaultFetchBufferSize
	^self at: #defaultFetchBufferSize ifAbsentPut: [1024]