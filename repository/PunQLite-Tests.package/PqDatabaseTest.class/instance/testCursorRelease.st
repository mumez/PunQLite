testing
testCursorRelease
	"self debug: #testCursorRelease"
	| ok cursor |

	1 to: 10 do: [:idx |
		ok := self database 
			storeAt: idx asString 
			value: 'value-', idx asString.
		self assert: ok ].
	
	cursor := self database newCursor.
	self assert: cursor isOpen.
	cursor close.
	self deny: cursor isOpen