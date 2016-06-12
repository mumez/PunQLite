enumerating
selectAll
	"Answer all documents in a collection"
	| executor |
	executor := self jx9SelectAll.
	executor reset.
	executor execute.
	^ (executor extract: 'records') asArray