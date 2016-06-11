enumerating
selectAll
	| executor |
	executor := self jx9SelectAll.
	executor reset.
	executor execute.
	^ (executor extract: 'records') asArray