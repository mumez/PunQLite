Extension { #name : #SequenceableCollection }

{ #category : #'*PunQlite-Jx9' }
SequenceableCollection >> jx9ValueOn: anExecutor [
	^ anExecutor newStructure: nil array: self
]
