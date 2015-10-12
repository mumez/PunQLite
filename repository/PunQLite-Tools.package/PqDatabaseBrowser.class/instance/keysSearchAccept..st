private - filtering
keysSearchAccept: aString

	 aString isEmptyOrNil
		ifTrue: [ self keysFilterPattern: nil ]
		ifFalse: [ self keysFilterPattern: 
					([ aString asRegexIgnoringCase ] on: RegexSyntaxError do: [ aString ])].
 