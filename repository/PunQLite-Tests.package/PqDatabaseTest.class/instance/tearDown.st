running
tearDown
	database ifNil: [ ^ self ].
	database close