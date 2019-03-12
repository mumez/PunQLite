Extension { #name : #SmallInteger }

{ #category : #'*PunQlite-Jx9' }
SmallInteger >> jx9ResultOn: aContext [
	^ aContext newResultInteger: self
]

{ #category : #'*PunQlite-Jx9' }
SmallInteger >> jx9ValueOn: anExecutor [
	^ anExecutor newScalarInteger: self
]
