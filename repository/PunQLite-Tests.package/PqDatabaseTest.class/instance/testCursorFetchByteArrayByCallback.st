testing
testCursorFetchByteArrayByCallback
	"self debug: #testCursorFetchByteArrayByCallback"
	| ok cursor val |

	1 to: 10 do: [ :index |
		ok := self database 
			storeAt: (ByteArray with: index) 
			value: ('value-', index asString) asByteArray.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	
	cursor first.
	self assert: cursor currentKey equals: #[1].
	cursor currentValueInto: [:data | val := data].
	self assert: val equals: 'value-1' asByteArray.
	
	cursor next.
	self assert: cursor currentKey equals: #[2].
	cursor currentValueInto: [:data | val := data].
	self assert: val equals: 'value-2' asByteArray.
	
	cursor last.
	self assert: cursor currentKey equals: #[10].
	cursor currentValueInto: [:data | val := data].
	self assert: val equals: 'value-10' asByteArray.
	
	cursor close.
	self deny: cursor isOpen