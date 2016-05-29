versions
version20: spec
	<version: '2.0' imports: #('2.0-baseline' )>

	spec for: #'pharo' do: [
		spec blessing: #'development'.
		spec description: 'External binding now with UFFI instead of NativeBoost. Intended for Pharo 5 onwards'.
		spec author: 'TorstenBergmann'.
		spec timestamp: '05/11/2016'.
		spec 
			package: 'PunQLite-Core' with: 'PunQLite-Core-TorstenBergmann.28';
			package: 'PunQLite-DB' with: 'PunQLite-DB-TorstenBergmann.16';
			package: 'PunQLite-Jx9' with: 'PunQLite-Jx9-TorstenBergmann.12';
			package: 'PunQLite-Help' with: 'PunQLite-Help-TorstenBergmann.1';
			package: 'PunQLite-Tools' with: 'PunQLite-Tools-TorstenBergmann.7';			
			package: 'PunQLite-Tests' with: 'PunQLite-Tests-TorstenBergmann.15'. ].
