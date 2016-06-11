private
ensureCollection
	| executor |
	executor := self jx9Create.
	executor reset.
	executor execute.
	self validateResultFrom: executor