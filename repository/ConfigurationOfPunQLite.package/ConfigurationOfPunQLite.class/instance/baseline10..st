baselines
baseline10: spec
	<version: '1.0-baseline'>

	spec for: #'pharo' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/MasashiUmezawa/PunQLite/main'.
		spec 
			package: 'PunQLite-Core' with: [
				spec requires: #(). ];
			package: 'PunQLite-DB' with: [
				spec requires: #('PunQLite-Core' ). ];
			package: 'PunQLite-Tests'.
		spec 
			group: 'default' with: #('Core' );
			group: 'Core' with: #('PunQLite-Core' 'PunQLite-DB' );
			group: 'Tests' with: #('PunQLite-Tests' ). ].
