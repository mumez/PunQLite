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
			package: 'PunQLite-DB-Codec';
			package: 'PunQLite-DB' 		with: [ spec requires: #('PunQLite-Core' 'PunQLite-DB-Codec') ];
			package: 'PunQLite-Jx9' 		with: [ spec requires: #('PunQLite-DB') ];
			package: 'PunQLite-Tools' 	with: [ spec requires: #('PunQLite-DB') ];
			package: 'PunQLite-Tests' 	with: [ spec requires: #('PunQLite-Jx9' 'PunQLite-DB-Codec') ].

		spec
			group: 'default' with: #('Core' 'Tests');
			group: 'Core' with: #('PunQLite-Core' 'PunQLite-DB-Codec' 'PunQLite-DB' 'PunQLite-Jx9' );
			group: 'Tools' with: #('PunQLite-Tools');
			group: 'Tests' with: #('PunQLite-Tests') ]
]

{ #category : #accessing }
BaselineOfPunQLite >> platformLibraryName [
	" Answer a name for the compiled version of the library "
	| os |
	os := Smalltalk os.
	os isUnix ifTrue: [ ^ 'unqlite.so' ].
	os isWindows ifTrue: [ ^ 'unqlite.dll' ].
	os isMacOSX ifTrue: [ ^ 'unqlite.dylib' ].

	self error: 'Unsupported OS platform'
]

{ #category : #private }
BaselineOfPunQLite >> binaryNotFoundWarningTemplate [
	" Answer a warning message template for missing UnQLite library "

	^ '================================================
WARNING: UnQLite library not found
================================================
Library needed: {1}
Location: {2}

Please compile UnQLite from source (2 files only):
{3}

Download source: https://github.com/symisc/unqlite
Documentation: https://github.com/mumez/PunQLite#installation
================================================'
]

{ #category : #private }
BaselineOfPunQLite >> compilationInstructions [
	" Answer platform-specific compilation instructions "

	Smalltalk os isUnix ifTrue: [
		^ 'gcc -c unqlite.c
gcc -shared -o unqlite.so unqlite.o' ].

	Smalltalk os isMacOSX ifTrue: [
		^ 'gcc -c unqlite.c
gcc -dynamiclib -o unqlite.dylib unqlite.o' ].

	Smalltalk os isWin32 ifTrue: [
		^ 'gcc -c unqlite.c
gcc -shared -static-libgcc -o unqlite.dll unqlite.o -Wl,--add-stdcall-alias' ].

	^ 'gcc -c unqlite.c
gcc -shared -o <library> unqlite.o'
]

{ #category : #doits }
BaselineOfPunQLite >> preLoad [
	" Check if UnQLite library exists, log instructions if not "

	self platformLibraryName asFileReference exists
		ifTrue: [ ^ self ].

	Transcript
		cr;
		crShow: self binaryNotFoundWarning
]

{ #category : #private }
BaselineOfPunQLite >> binaryNotFoundWarning [

	^ self binaryNotFoundWarningTemplate format: {
		self platformLibraryName.
		FileLocator imageDirectory fullName.
		self compilationInstructions }
]
