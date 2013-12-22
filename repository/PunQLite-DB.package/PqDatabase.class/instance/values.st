actions-dictionary
values
	| values |
	values := OrderedCollection new.
	self do: [:cursor |
		values add: (cursor currentValue)	
	].
	^values asArray