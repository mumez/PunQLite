Extension { #name : #Float }

{ #category : #'*PunQlite-Jx9' }
Float >> jx9ResultOn: aContext [
	^ aContext newResultDouble: self
]

{ #category : #'*PunQlite-Jx9' }
Float >> jx9ValueOn: anExecutor [
	^ anExecutor newScalarDouble: self
]
