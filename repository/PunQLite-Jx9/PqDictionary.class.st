"
I'm a special kind of dictionary who can access properties directly (using the DNU mechanism).
This allow us to do some queries, etc. in a more clear way.
For example, let's see: 

... where: [ :each | ((each at: 'name') at: 'firstName') = 'Esteban' ]

can be expressed as this instead: 

... where: [ :each | each name firstName = 'Esteban' ]

"
Class {
	#name : #PqDictionary,
	#superclass : #Dictionary,
	#category : #'PunQLite-Jx9-Base'
}

{ #category : #'reflective operations' }
PqDictionary >> doesNotUnderstand: aMessage [

	aMessage selector last ~= $: ifTrue: [ 
		self 
			at: aMessage selector
			ifPresent: [ :value | ^ value ] ].

	^ super doesNotUnderstand: aMessage
]

{ #category : #private }
PqDictionary >> species [

	^ Dictionary
]
