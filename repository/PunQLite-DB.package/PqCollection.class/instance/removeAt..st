accessing
removeAt: anId
	| executor id |
	
	executor := self jx9Remove.
	id := (anId jx9ValueOn: executor) name: 'id'.
	executor inject: id.
	executor execute.
	executor release: id.
	self validateResultFrom: executor