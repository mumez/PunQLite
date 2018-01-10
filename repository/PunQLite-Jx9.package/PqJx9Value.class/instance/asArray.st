enumerating
asArray 
	^ Array streamContents: [ :stream | 
		self do: [ :each | stream nextPut: each value ] ]
