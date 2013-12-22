accessing
defaultFetchBufferSize: anInteger
	^self at: #defaultFetchBufferSize ifAbsentPut: anInteger