converting
value 
	self isString ifTrue: [ ^ self asString ].	
	self isInt ifTrue: [ ^ self asInt ].
	self isBoolean ifTrue: [ ^ self asBool ].
	self isNull ifTrue: [ ^ nil ].
	self isFloat ifTrue: [ ^ self asDouble ].
	self isJsonObject ifTrue: [ ^ self asDictionary ].
	self isJsonArray ifTrue: [ ^ self asArray ].
	self isResource ifTrue: [ ^ self asResource ].
	
	self error: 'unknown data type'