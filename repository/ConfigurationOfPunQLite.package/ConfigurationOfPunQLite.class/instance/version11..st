versions
version11: spec
	<version: '1.1' imports: #('1.1-baseline' )>

	spec for: #'pharo' do: [
		spec blessing: #'development'.
		spec 
			package: 'PunQLite-Core' with: 'PunQLite-Core-MasashiUmezawa.5';
			package: 'PunQLite-DB' with: 'PunQLite-DB-MasashiUmezawa.5';
			package: 'PunQLite-Jx9' with: 'PunQLite-Jx9-MasashiUmezawa.4';
			package: 'PunQLite-Tests' with: 'PunQLite-Tests-MasashiUmezawa.3'. ].
