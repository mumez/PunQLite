versions
version10: spec
	<version: '1.0' imports: #('1.0-baseline' )>

	spec for: #'pharo' do: [
		spec blessing: #'development'.
		spec 
			package: 'PunQLite-Core' with: 'PunQLite-Core-MasashiUmezawa.1';
			package: 'PunQLite-DB' with: 'PunQLite-DB-MasashiUmezawa.1';
			package: 'PunQLite-Tests' with: 'PunQLite-Tests-MasashiUmezawa.1'. ].
