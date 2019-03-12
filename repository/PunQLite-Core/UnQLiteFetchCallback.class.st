"
A  callback to fetch data from UnQLite database
"
Class {
	#name : #UnQLiteFetchCallback,
	#superclass : #FFICallback,
	#category : 'PunQLite-Core-FFI'
}

{ #category : #accessing }
UnQLiteFetchCallback class >> fnSpec [
	^ #(int ( void *fetchData, uint dataLen, void *userData ))
]

{ #category : #accessing }
UnQLiteFetchCallback class >> on: aBlock [ 
	^ self signature: self fnSpec block: aBlock
]
