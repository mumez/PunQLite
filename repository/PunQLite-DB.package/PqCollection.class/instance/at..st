accessing
at: anId
	| executor id |
	
	executor := self jx9At.
	id := (anId jx9ValueOn: executor) name: 'id'.
	executor inject: id.
	executor execute.
	executor release: id.	
	^ (executor extract: 'record') value