transactions
transact: aBlock
	self beginTransaction.
	aBlock ensure: [ 
		(self commitTransaction) ifFalse: [ 
			self rollbackTransaction. 
			PqError signal: 'Could not commit.' ] ].