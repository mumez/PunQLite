versions
version114: spec
	<version: '1.1.4' imports: #('1.1.4-baseline' )>

	spec for: #'pharo' do: [
		spec blessing: #'development'.
		spec 
			package: 'PunQLite-Core' with: 'PunQLite-Core-PierceNg.17';
			package: 'PunQLite-DB' with: 'PunQLite-DB-TorstenBergmann.11';
			package: 'PunQLite-Jx9' with: 'PunQLite-Jx9-PierceNg.9';
			package: 'PunQLite-Help' with: 'PunQLite-Help-TorstenBergmann.1';
			package: 'PunQLite-Tools' with: 'PunQLite-Tools-TorstenBergmann.7';			
			package: 'PunQLite-Tests' with: 'PunQLite-Tests-PierceNg.11'. ].
