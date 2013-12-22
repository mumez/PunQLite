actions-dictionary
keys
	| keys |
	keys := OrderedCollection new.
	self do: [:cursor |
		keys add: (cursor currentStringKey)	
	].
	^keys asArray