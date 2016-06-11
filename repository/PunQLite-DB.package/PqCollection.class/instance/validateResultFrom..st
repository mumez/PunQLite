private
validateResultFrom: anExecutor
	(anExecutor extract: 'result') asBool 
		ifFalse: [ PqCollectionError signal: (anExecutor extract: 'errorMessage') asString ]	
