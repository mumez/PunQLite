baselines
baseline20: spec
	<version: '2.0-baseline'>

	spec for: #'pharo' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/MasashiUmezawa/PunQLite/main'.
		spec preLoadDoIt: #preLoad.
		spec 
			package: 'PunQLite-Core' with: [
				spec requires: #(). ];
			package: 'PunQLite-DB' with: [
				spec requires: #('PunQLite-Core' ). ];
			package: 'PunQLite-Jx9' with: [
				spec requires: #('PunQLite-DB' ). ];
			package: 'PunQLite-Help';
			package: 'PunQLite-Tools' with: [
				spec requires: #('PunQLite-DB').
			];
			package: 'PunQLite-Tests' with: [
				spec requires: #('PunQLite-Jx9'). ].
		spec 
			group: 'default' with: #('Core' 'Help' 'Tests' 'Tools');
			group: 'Core' with: #('PunQLite-Core' 'PunQLite-DB' 'PunQLite-Jx9' );
			group: 'Help' with: #('PunQLite-Help');
			group: 'Tools' with: #('PunQLite-Tools');
			group: 'Tests' with: #('PunQLite-Tests'). ].
