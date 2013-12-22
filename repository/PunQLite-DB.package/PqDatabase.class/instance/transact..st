transactions
transact: aBlock
	self beginTransaction.
	aBlock value.
	self commitTransaction.