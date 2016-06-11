enumerating
asArray 
	| arrayStream |

	arrayStream := Array new writeStream.
	self do: [ :each | arrayStream nextPut: each value ].
	^ arrayStream contents