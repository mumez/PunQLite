Extension { #name : #Boolean }

{ #category : #'*PunQlite-Jx9' }
Boolean >> jx9ResultOn: aContext [
	^ aContext newResultBoolean: self
]

{ #category : #'*PunQlite-Jx9' }
Boolean >> jx9ValueOn: anExecutor [
	^ anExecutor newScalarBoolean: self
]
