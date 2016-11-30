versions
v1_1_4: spec
	<version: '1.1.4'>

	spec for: #'common' do: [ 
		spec blessing: #'stable'.
		spec
			baseline: 'PunQLite' with: [ 
				spec repository: 'github://pharo-nosql/PunQLite:1.1.4/repository' ];
			import: 'PunQLite' ]