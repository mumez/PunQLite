"
A  callback to fetch data from UnQLite database
"
Class {
	#name : 'UnQLiteFetchCallback',
	#superclass : 'UnQLiteCallback',
	#category : 'PunQLite-Core-FFI',
	#package : 'PunQLite-Core',
	#tag : 'FFI'
}

{ #category : 'accessing' }
UnQLiteFetchCallback class >> fnSpec [

	^ #(int ( void *fetchData, uint dataLen, void *userData ))
]

{ #category : 'instance creation' }
UnQLiteFetchCallback class >> on: aBlock [ 

	^ self 
		signature: self fnSpec 
		block: aBlock
]
