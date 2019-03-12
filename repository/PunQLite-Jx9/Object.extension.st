Extension { #name : #Object }

{ #category : #'*PunQlite-Jx9' }
Object >> jx9ResultOn: aContext [
	PqJx9Error signal: 'Cannot return value of class ', self className
]

{ #category : #'*PunQlite-Jx9' }
Object >> jx9ValueOn: anExecutor [
	PqJx9Error signal: 'Cannot store value of class ', self className
]
