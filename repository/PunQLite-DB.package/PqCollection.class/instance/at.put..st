accessing
at: anId put: jsonDictionary
	"Replaces the contents of document id 'anId' with new contents"
	| executor data id |

	executor := self jx9AtPut.
	executor reset.
	id := (anId jx9ValueOn: executor) name: 'id'.
	executor inject: id.
	data := executor newStructure: 'record' json: jsonDictionary.
	executor inject: data.
	executor execute.
	self validateResultFrom: executor.
	