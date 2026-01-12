Extension { #name : #Dictionary }

{ #category : #'*PunQlite-Jx9' }
Dictionary >> jx9ValueOn: anExecutor [
	^ anExecutor newStructure: nil json: self
]
