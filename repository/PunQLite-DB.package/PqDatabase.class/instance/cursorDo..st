actions-cursor
cursorDo: aBlock
	| cur |
	[cur := self newCursor.
	aBlock value: cur.
	] ensure: [cur ifNotNil: [cur close]]