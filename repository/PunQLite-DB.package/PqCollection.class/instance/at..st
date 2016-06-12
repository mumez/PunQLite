accessing
at: anId
	"retrieves a documents with id or nil if not found"
	| executor id |
	
	executor := self jx9At.
	executor reset.
	id := (anId jx9ValueOn: executor) name: 'id'.
	executor inject: id.
	executor execute.
	executor release: id.	
	^ (executor extract: 'record') value