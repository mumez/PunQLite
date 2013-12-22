actions-dictionary
size
	| size |
	size := 0.
	self do: [:cur | size := size + 1].
	^size