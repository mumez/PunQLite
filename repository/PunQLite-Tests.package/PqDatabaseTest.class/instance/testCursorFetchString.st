testing
testCursorFetchString
	"self debug: #testCursorFetchString"
	| ok cursor |

	1 to: 10 do: [ :index |
		ok := self database 
			storeAt: index asString 
			value: 'value-', index asString.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	cursor first.
	self assert: cursor currentStringKey equals: '1'.
	self assert: cursor currentStringValue equals: 'value-1'.
	
	cursor next.
	self assert: cursor currentStringKey equals: '2'.
	self assert: cursor currentStringValue equals: 'value-2'.
	
	cursor last.
	self assert: cursor currentStringKey equals: '10'.
	self assert: cursor currentStringValue equals: 'value-10'.
	
	cursor previous.
	self assert: cursor currentStringKey equals: '9'.
	self assert: cursor currentStringValue equals: 'value-9'.
	
	cursor reset.
	self assert: cursor currentStringKey equals: '1'.
	self assert: cursor currentStringValue equals: 'value-1'.
	
	cursor close.
	self assert: cursor isOpen not.