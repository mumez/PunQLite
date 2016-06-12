accessing
removeAt: anId
	"Removes the document with id 'anId'"
	| executor id |
	
	executor := self jx9Remove.
	executor reset.
	id := (anId jx9ValueOn: executor) name: 'id'.
	executor inject: id.
	executor execute.
	executor release: id.
	self validateResultFrom: executor