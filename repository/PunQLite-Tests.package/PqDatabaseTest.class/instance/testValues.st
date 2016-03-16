testing
testValues
	"self debug: #testValues"
	| ok values |

	1 to: 10 do: [:idx |
		ok := self database storeAt: idx asString value: 'value-', idx asString.
		self assert: ok ].
	
	self assert: self database size equals: 10.
	
	values := self database values collect: [:each | each asString].
	self assert: values equals:  #('value-1' 'value-2' 'value-3' 'value-4' 'value-5' 'value-6' 'value-7' 'value-8' 'value-9' 'value-10')