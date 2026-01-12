Extension { #name : #Integer }

{ #category : #'*PunQlite-Jx9' }
Integer >> jx9ResultOn: aContext [
	^ aContext newResultInteger64: self
]

{ #category : #'*PunQlite-Jx9' }
Integer >> jx9ValueOn: anExecutor [
	^ anExecutor newScalarInteger64: self
]
