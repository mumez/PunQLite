"
A configuration for PunQLite database project

Instance Variables
	project:		<Object>

project
	- xxxxx

"
Class {
	#name : #ConfigurationOfPunQLite,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : 'ConfigurationOfPunQLite'
}

{ #category : #'development support' }
ConfigurationOfPunQLite class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>

]

{ #category : #private }
ConfigurationOfPunQLite class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #MetacelloBaseConfiguration ifAbsent: aBlock ].

]

{ #category : #catalog }
ConfigurationOfPunQLite class >> catalogChangeLog [
		
 ^ '- Version 1.1
[[[
(ConfigurationOfPunQLite project version: ''1.1'') load
]]]
- Version 1.1.1
[[[
(ConfigurationOfPunQLite project version: ''1.1.1'') load
]]]
- Version 1.1.2
[[[
(ConfigurationOfPunQLite project version: ''1.1.2'') load
]]]
- Version 1.1.3
[[[
(ConfigurationOfPunQLite project version: ''1.1.3'') load
]]]
'
	
	
]

{ #category : #catalog }
ConfigurationOfPunQLite class >> catalogDescription [

^ 
'UnQLite binding for Pharo Smalltalk. UnQLite is a fast, lightweight, portable, embedded KVS with a simple scripting engine (Jx9). By using PunQLite, you can store/load lots of data as if just using a normal Dictionary.

PunQLite uses UnQLite shared library. If you have no time to compile, just get pre-built binary from the github project page (https://github.com/pharo-nosql/PunQLite).
'
]

{ #category : #catalog }
ConfigurationOfPunQLite class >> catalogKeyClassesAndExample [

	^ 'It is composed of some keys classes: 
		
- ==PqDatabase== represents a database. You can open a DB and put/get values like a dictionary.
		
- ==PqCursor== is an iterator on a database. You can jump to the specific point by seek:. 

Example:
[[[ 
db := PqDatabase openOnMemory.
db at: ''Smalltalk'' put: ''COOL''.
db at: ''Pharo'' put: ''HOT''.
db at: ''Smalltalk'' ifPresent: [:data |
    data asString inspect
].
Transcript cr; show: db keys.
db do: [:cursor |
    Transcript cr; show: cursor currentStringKey; space; show: cursor currentStringValue.       
].
db close.
]]]
	
Tests of the ==PqDatabase== class are the place to start to learn the API.
You can see more samples on github (https://github.com/mumez/PunQLite). 

'
]

{ #category : #catalog }
ConfigurationOfPunQLite class >> catalogKeywords [
	^ #(persistence database unqlite KVS nosql)
]

{ #category : #private }
ConfigurationOfPunQLite class >> ensureMetacello [

	(self baseConfigurationClassIfAbsent: []) ensureMetacello
]

{ #category : #private }
ConfigurationOfPunQLite class >> ensureMetacelloBaseConfiguration [

  Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			| repository version |
			repository := MCHttpRepository location: 'http://seaside.gemstone.com/ss/metacello' user: '' password: ''.
			repository
				versionReaderForFileNamed: 'Metacello-Base-DaleHenrichs.2.mcz'
				do: [ :reader | 
					version := reader version.
					version load.
					version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
ConfigurationOfPunQLite class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfPunQLite class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfPunQLite class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfPunQLite class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #accessing }
ConfigurationOfPunQLite class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfPunQLite class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #baselines }
ConfigurationOfPunQLite >> baseline10: spec [
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

]

{ #category : #baselines }
ConfigurationOfPunQLite >> baseline112: spec [
	<version: '1.1.2-baseline'>

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

]

{ #category : #baselines }
ConfigurationOfPunQLite >> baseline113: spec [
	<version: '1.1.3-baseline'>

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

]

{ #category : #baselines }
ConfigurationOfPunQLite >> baseline114: spec [
	<version: '1.1.4-baseline'>

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

]

{ #category : #baselines }
ConfigurationOfPunQLite >> baseline11: spec [
	<version: '1.1-baseline'>

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
			package: 'PunQLite-Tests' with: [
				spec requires: #('PunQLite-Jx9'). ].
		spec 
			group: 'default' with: #('Core' 'Tests');
			group: 'Core' with: #('PunQLite-Core' 'PunQLite-DB' 'PunQLite-Jx9' );
			group: 'Tests' with: #('PunQLite-Tests' ). ].

]

{ #category : #accessing }
ConfigurationOfPunQLite >> customProjectAttributes [
    "Edit to return a collection of any custom attributes e.g. for conditional loading: Array with: #'Condition1' with: #'Condition2.
	For more information see: http://code.google.com/p/metacello/wiki/CustomProjectAttrributes "

    ^ #()
]

{ #category : #versions }
ConfigurationOfPunQLite >> dev: spec [
	<version: 'dev'>

	spec for: #'common' do: [ 
		spec blessing: #'stable'.
		spec
			baseline: 'PunQLite' with: [ 
				spec repository: 'github://pharo-nosql/PunQLite:master/repository' ];
			import: 'PunQLite' ]
]

{ #category : #'symbolic versions' }
ConfigurationOfPunQLite >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'pharo' version: 'dev'.

]

{ #category : #'private - accessing' }
ConfigurationOfPunQLite >> platformLibraryName [
	" Answer a name for the compiled version of the library "

	Smalltalk os isWin32 
		ifTrue: [ ^ 'lib-unqlite.dll.zip' ].
	Smalltalk os isUnix 
		ifTrue: [ ^ 'lib-unqlite.so.zip' ].
	Smalltalk os isMacOSX
		ifTrue: [ ^ 'lib-unqlite.dylib.zip' ].
	self error: 'Unsupported OS platform'.
]

{ #category : #'private - accessing' }
ConfigurationOfPunQLite >> platformLibraryUrl [
	" Answer a download URL for the compiled version of library "

	^'https://github.com/mumez/PunQLite/releases/download/v1.1.2/', self platformLibraryName 
]

{ #category : #doits }
ConfigurationOfPunQLite >> preLoad [

	| url fileRef response |

	url := self platformLibraryUrl asZnUrl.
	fileRef := FileSystem disk workingDirectory / url pathSegments last.
	(response := ZnEasy get: url) isSuccess
		ifTrue: [ fileRef writeStreamDo: [ : stream | stream nextPutAll: response contents ] ]
		ifFalse: [ self error: 'Cannot download compiled library file' ].
	self uncompress: fileRef.
]

{ #category : #accessing }
ConfigurationOfPunQLite >> project [
    ^ project
        ifNil: [ 
            "Bootstrap Metacello if it is not already loaded"
            self class ensureMetacello.
            project := MetacelloMCProject new projectAttributes: self customProjectAttributes.	"Create the Metacello project"
            (Smalltalk at: #'MetacelloVersionConstructor') on: self project: project.	"Construct the project"
            project loadType: #'linear'.	"change to #atomic if desired"
            project ]
]

{ #category : #'symbolic versions' }
ConfigurationOfPunQLite >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'pharo' version: '1.1.4'.

]

{ #category : #'private - utilities' }
ConfigurationOfPunQLite >> uncompress: fileRef [
	| dst zipArchive |
	dst := FileSystem workingDirectory / 'pharo-vm'.
	(fileRef fullName endsWith: '.zip')
		ifFalse: [ self error: 'Cannot extract library from file: ' , fileRef printString ].
	[ zipArchive := ZipArchive new.
	zipArchive readFrom: fileRef fullName.
	UIManager default informUserDuring: [ :bar | zipArchive extractAllTo: dst informing: bar overwrite: true ] ]
		ensure: [ zipArchive ifNotNil: [zipArchive close]].
	fileRef delete
]

{ #category : #versions }
ConfigurationOfPunQLite >> v1_1_4: spec [
	<version: '1.1.4'>

	spec for: #'common' do: [ 
		spec blessing: #'stable'.
		spec
			baseline: 'PunQLite' with: [ 
				spec repository: 'github://pharo-nosql/PunQLite:1.1.4/repository' ];
			import: 'PunQLite' ]
]

{ #category : #versions }
ConfigurationOfPunQLite >> version10: spec [
	<version: '1.0' imports: #('1.0-baseline' )>

	spec for: #'pharo' do: [
		spec blessing: #'development'.
		spec 
			package: 'PunQLite-Core' with: 'PunQLite-Core-MasashiUmezawa.1';
			package: 'PunQLite-DB' with: 'PunQLite-DB-MasashiUmezawa.1';
			package: 'PunQLite-Tests' with: 'PunQLite-Tests-MasashiUmezawa.1'. ].

]

{ #category : #versions }
ConfigurationOfPunQLite >> version111: spec [
	<version: '1.1.1' imports: #('1.1-baseline' )>

	spec for: #'pharo' do: [
		spec blessing: #'development'.
		spec 
			package: 'PunQLite-Core' with: 'PunQLite-Core-MasashiUmezawa.11';
			package: 'PunQLite-DB' with: 'PunQLite-DB-MasashiUmezawa.8';
			package: 'PunQLite-Jx9' with: 'PunQLite-Jx9-MasashiUmezawa.5';
			package: 'PunQLite-Tests' with: 'PunQLite-Tests-MasashiUmezawa.8'. ].

]

{ #category : #versions }
ConfigurationOfPunQLite >> version112: spec [
	<version: '1.1.2' imports: #('1.1.2-baseline' )>

	spec for: #'pharo' do: [
		spec blessing: #'development'.
		spec 
			package: 'PunQLite-Core' with: 'PunQLite-Core-TorstenBergmann.14';
			package: 'PunQLite-DB' with: 'PunQLite-DB-TorstenBergmann.11';
			package: 'PunQLite-Jx9' with: 'PunQLite-Jx9-TorstenBergmann.6';
			package: 'PunQLite-Help' with: 'PunQLite-Help-TorstenBergmann.1';
			package: 'PunQLite-Tools' with: 'PunQLite-Tools-TorstenBergmann.6';			
			package: 'PunQLite-Tests' with: 'PunQLite-Tests-TorstenBergmann.9'. ].

]

{ #category : #versions }
ConfigurationOfPunQLite >> version113: spec [
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

]

{ #category : #versions }
ConfigurationOfPunQLite >> version11: spec [
	<version: '1.1' imports: #('1.1-baseline' )>

	spec for: #'pharo' do: [
		spec blessing: #'development'.
		spec 
			package: 'PunQLite-Core' with: 'PunQLite-Core-MasashiUmezawa.11';
			package: 'PunQLite-DB' with: 'PunQLite-DB-MasashiUmezawa.6';
			package: 'PunQLite-Jx9' with: 'PunQLite-Jx9-MasashiUmezawa.5';
			package: 'PunQLite-Tests' with: 'PunQLite-Tests-MasashiUmezawa.7'. ].

]
