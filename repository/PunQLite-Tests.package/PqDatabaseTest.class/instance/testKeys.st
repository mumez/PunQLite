testing
testKeys
	"self debug: #testKeys"
	| ok |

	1 to: 10 do: [:index |
		ok := self database 
			storeAt: index asString 
			value: 'value-', index asString.
		self assert: ok ].
	
	self assert: self database size equals: 10.
	self assert: self database keys equals: #('1' '2' '3' '4' '5' '6' '7' '8' '9' '10')
