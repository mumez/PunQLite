Extension { #name : #Symbol }

{ #category : #'*PunQlite-Jx9' }
Symbol >> jx9ValueOn: anExecuter [
	^ anExecuter newScalarString: self asString
]
