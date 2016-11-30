versions
dev: spec
	<version: 'dev'>

	spec for: #'common' do: [ 
		spec blessing: #'stable'.
		spec
			baseline: 'PunQLite' with: [ 
				spec repository: 'github://pharo-nosql/PunQLite:master/repository' ];
			import: 'PunQLite' ]