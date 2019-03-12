Class {
	#name : #UnQLiteLibrary,
	#superclass : #FFILibrary,
	#category : 'PunQLite-Core-FFI'
}

{ #category : #'accessing platform' }
UnQLiteLibrary >> macModuleName [
	^ (FileLocator imageDirectory / 'unqlite.dylib') fullName
]

{ #category : #'accessing platform' }
UnQLiteLibrary >> unixModuleName [
	^ (FileLocator imageDirectory / 'unqlite.so') fullName
]

{ #category : #'accessing platform' }
UnQLiteLibrary >> win32ModuleName [
	^ (FileLocator imageDirectory / 'unqlite.dll') fullName
]
