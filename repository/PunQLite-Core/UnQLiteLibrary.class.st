Class {
	#name : #UnQLiteLibrary,
	#superclass : #FFILibrary,
	#instVars : [
		'runner'
	],
	#category : #'PunQLite-Core-FFI'
}

{ #category : #accessing }
UnQLiteLibrary >> calloutAPIClass [ 

	^ TFCalloutAPI
]

{ #category : #'accessing platform' }
UnQLiteLibrary >> macLibraryName [
	^ (FileLocator imageDirectory / 'unqlite.dylib') fullName
]

{ #category : #accessing }
UnQLiteLibrary >> runner [
	
	"^ runner ifNil: [ runner := TFWorker named: 'UnQLite' ]"
	^ TFSameThreadRunner uniqueInstance
]

{ #category : #'accessing platform' }
UnQLiteLibrary >> unixModuleName [
	^ (FileLocator imageDirectory / 'unqlite.so') fullName
]

{ #category : #'accessing platform' }
UnQLiteLibrary >> win32LibraryName [
	^ (FileLocator imageDirectory / 'unqlite.dll') fullName
]
