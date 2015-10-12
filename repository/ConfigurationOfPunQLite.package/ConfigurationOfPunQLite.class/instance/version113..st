versions
version113: spec
	<version: '1.1.3' imports: #('1.1.3-baseline' )>

	spec for: #'pharo' do: [
		spec blessing: #'development'.
		spec 
			package: 'PunQLite-Core' with: 'PunQLite-Core-TorstenBergmann.14';
			package: 'PunQLite-DB' with: 'PunQLite-DB-TorstenBergmann.11';
			package: 'PunQLite-Jx9' with: 'PunQLite-Jx9-TorstenBergmann.6';
			package: 'PunQLite-Help' with: 'PunQLite-Help-TorstenBergmann.1';
			package: 'PunQLite-Tools' with: 'PunQLite-Tools-TorstenBergmann.7';			
			package: 'PunQLite-Tests' with: 'PunQLite-Tests-TorstenBergmann.9'. ].
