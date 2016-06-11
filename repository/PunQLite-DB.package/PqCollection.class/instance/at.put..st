accessing
at: anId put: aDictionary
	| executor data id |

	executor := self jx9AtPut.
	id := (anId jx9ValueOn: executor) name: 'id'.
	executor inject: id.
	data := executor newStructure: 'record' json: aDictionary.
	executor inject: data.
	executor execute.
	self validateResultFrom: executor.
	