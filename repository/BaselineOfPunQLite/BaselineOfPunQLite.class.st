Class {
	#name : #BaselineOfPunQLite,
	#superclass : #BaselineOf,
	#category : 'BaselineOfPunQLite'
}

{ #category : #baseline }
BaselineOfPunQLite >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec blessing: #baseline.
		spec preLoadDoIt: #preLoad.

		spec 
			package: 'PunQLite-Core';
			package: 'PunQLite-DB' 		with: [ spec requires: #('PunQLite-Core' ) ];
			package: 'PunQLite-Jx9' 		with: [ spec requires: #('PunQLite-DB') ];
			package: 'PunQLite-Help';
			package: 'PunQLite-Tools' 	with: [ spec requires: #('PunQLite-DB') ];
			package: 'PunQLite-Tests' 	with: [ spec requires: #('PunQLite-Jx9') ].
		
		spec 
			group: 'default' with: #('Core' 'Help' 'Tests' 'Tools');
			group: 'Core' with: #('PunQLite-Core' 'PunQLite-DB' 'PunQLite-Jx9' );
			group: 'Help' with: #('PunQLite-Help');
			group: 'Tools' with: #('PunQLite-Tools');
			group: 'Tests' with: #('PunQLite-Tests') ]
]

{ #category : #accessing }
BaselineOfPunQLite >> platformLibraryName [
	" Answer a name for the compiled version of the library "

	Smalltalk os isUnix  		ifTrue: [ ^ 'unqlite.so' ].
	Smalltalk os isWin32 		ifTrue: [ ^ 'unqlite.dll' ].
	Smalltalk os isMacOSX 	ifTrue: [ ^ 'unqlite.dylib' ].
	
	self error: 'Unsupported OS platform'
]

{ #category : #accessing }
BaselineOfPunQLite >> platformLibraryUrl [
	" Answer a download URL for the compiled version of library "
	^'https://github.com/pharo-nosql/PunQLite/releases/download/stable/', self platformLibraryName 
]

{ #category : #doits }
BaselineOfPunQLite >> preLoad [
	self platformLibraryName asFileReference exists 
		ifTrue: [ ^ self ].

	ZnClient new
		url: self platformLibraryUrl;
		downloadTo: (FileLocator imageDirectory / self platformLibraryName) fullName.
]
