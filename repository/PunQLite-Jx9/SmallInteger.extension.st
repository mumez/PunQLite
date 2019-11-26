Extension { #name : #SmallInteger }

{ #category : #'*PunQlite-Jx9' }
SmallInteger >> jx9ResultOn: aContext [
	^ aContext newResultInteger: self
]

{ #category : #'*PunQlite-Jx9' }
SmallInteger >> jx9ValueOn: anExecutor [
	
	"I need to check for max size because an integer in unqlite = int and sizeof(int)=4"
	^ (self between: -16r80000000 and: 16r7FFFFFFF)
		ifTrue: [ anExecutor newScalarInteger: self ]
		ifFalse: [ anExecutor newScalarInteger64: self ]
]
