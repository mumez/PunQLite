testing
testCursorSeek
	"self debug: #testCursorSeek"
	| ok cursor |

	1 to: 10 do: [:idx |
		ok := self database 
			storeAt: idx asString 
			value: 'value-', idx asString.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	cursor seek: '5'.
	self assert: cursor currentStringValue equals: 'value-5'.

	cursor seek: '10'.
	self assert: cursor currentStringValue equals: 'value-10'.
	
	cursor seek: '3'.
	self assert: cursor currentStringValue equals: 'value-3'.
	
	self deny: (cursor seek: '100').
	
	cursor close.
	self deny: cursor isOpen