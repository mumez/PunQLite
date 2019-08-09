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
UnQLiteLibrary >> macModuleName [
	^ (FileLocator imageDirectory / 'unqlite.dylib') fullName
]

{ #category : #accessing }
UnQLiteLibrary >> runner [
	
	"^ runner ifNil: [ runner := TFWorker named: 'UnQLite' ]"
	^ TFSameThreadRunner new
]

{ #category : #'accessing platform' }
UnQLiteLibrary >> unixModuleName [
	^ (FileLocator imageDirectory / 'unqlite.so') fullName
]

{ #category : #'accessing platform' }
UnQLiteLibrary >> win32ModuleName [
	^ (FileLocator imageDirectory / 'unqlite.dll') fullName
]
