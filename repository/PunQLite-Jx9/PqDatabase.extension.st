Extension { #name : #PqDatabase }

{ #category : #'*PunQlite-Jx9' }
PqDatabase >> jx9 [
	^ PqJx9Executer on: self
]

{ #category : #'*PunQlite-Jx9' }
PqDatabase >> jx9Do: aBlock [
	| jx9 |
	
	jx9 := self jx9.
	[ aBlock value: jx9 ] 
	ensure: [ 
		jx9 release ]
]
