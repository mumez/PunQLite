testing
testCursorFetchByteArray
	"self debug: #testCursorFetchByteArray"
	| ok cursor |
	
	1 to: 10 do: [ :index |
		ok := self database 
			storeAt: (ByteArray with: index) 
			value: ('value-', index asString) asByteArray.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	cursor first.
	self assert: cursor currentKey equals: #[1].
	self assert: cursor currentValue equals: 'value-1' asByteArray.
	
	cursor next.
	self assert: cursor currentKey equals: #[2].
	self assert: cursor currentValue equals: 'value-2' asByteArray.
	
	cursor last.
	self assert: cursor currentKey equals: #[10].
	self assert: cursor currentValue equals: 'value-10' asByteArray.
	
	cursor previous.
	self assert: cursor currentKey equals: #[9].
	self assert: cursor currentValue equals: 'value-9' asByteArray.
	
	cursor reset.
	self assert: cursor currentKey equals: #[1].
	self assert: cursor currentValue equals: 'value-1' asByteArray.
	
	cursor close.
	self deny: cursor isOpen