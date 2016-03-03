testing
testAppender
	"self debug: #testAppender"
	| appender ok fetched |

	self deny: (self database includesKey: 'Smalltalk').
	
	appender := self database appenderAt: 'Smalltalk'.
	
	ok := appender 
		nextPutAll: 'COOL'; 
		nextPutAll: 'HOT'; 
		nextPutAll: 'COOL'.
	self assert: ok.
	
	fetched := self database fetchStringAt: 'Smalltalk'.
	self assert: fetched equals: 'COOLHOTCOOL'