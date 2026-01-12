Extension { #name : #UndefinedObject }

{ #category : #'*PunQlite-Jx9' }
UndefinedObject >> jx9ResultOn: aContext [
	^ aContext newResultNull
]

{ #category : #'*PunQlite-Jx9' }
UndefinedObject >> jx9ValueOn: anExecutor [
	^ anExecutor newScalarNull: self
]
