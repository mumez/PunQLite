baselines
baseline11: spec
	<version: '1.1-baseline'>

	spec for: #'pharo' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/MasashiUmezawa/PunQLite/main'.
		spec 
			package: 'PunQLite-Core' with: [
				spec requires: #(). ];
			package: 'PunQLite-DB' with: [
				spec requires: #('PunQLite-Core' ). ];
			package: 'PunQLite-Jx9' with: [
				spec requires: #('PunQLite-DB' ). ];
			package: 'PunQLite-Tests' with: [
				spec requires: #('PunQLite-Jx9'). ].
		spec 
			group: 'default' with: #('Core' 'Tests');
			group: 'Core' with: #('PunQLite-Core' 'PunQLite-DB' 'PunQLite-Jx9' );
			group: 'Tests' with: #('PunQLite-Tests' ). ].
