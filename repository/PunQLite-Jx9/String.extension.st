Extension { #name : #String }

{ #category : #'*PunQlite-Jx9' }
String >> jx9ResultOn: aContext [
	^ aContext newResultString: self
]

{ #category : #'*PunQlite-Jx9' }
String >> jx9ValueOn: anExecuter [
	^ anExecuter newScalarString: self
]
