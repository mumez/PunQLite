actions-cursor
newCursorAt: seekKey
	| cursor |
	cursor := self newCursor.
	(cursor seek: seekKey) ifTrue: [^cursor].
	^nil