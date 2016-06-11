private
newJx9Executor: aString 
	| jx9Executor |
	
	jx9Executor := self database jx9.
	jx9Executor compile: (aString format: { #name -> self name } asDictionary).
	^ jx9Executor