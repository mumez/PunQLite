"
This is a custom help book for the PUnQlite framework.

"
Class {
	#name : #PqHelp,
	#superclass : #CustomHelp,
	#category : 'PunQLite-Help'
}

{ #category : #accessing }
PqHelp class >> bookName [
	^'PUnQLite database'
]

{ #category : #pages }
PqHelp class >> introduction [
	"This method was automatically generated. Edit it using:"
	<script: 'PqHelp edit: #introduction'>
	^HelpTopic
		title: 'Introduction'
		contents: 
'UnQLite binding for Pharo Smalltalk. UnQLite is a fast, lightweight, portable, embedded KVS with a simple scripting engine (Jx9). By using PunQLite, you can store/load lots of data as if just using a normal Dictionary. !' readStream nextChunkText
]

{ #category : #pages }
PqHelp class >> links [
	"This method was automatically generated. Edit it using:"
	<script: 'self edit: #links'>
	^HelpTopic
		title: 'Links'
		contents: 
'Visit the following sites to get more informations on PunQLite

- https://github.com/mumez/PunQLite
- http://smalltalkhub.com/#!!/~MasashiUmezawa/PunQLite!' readStream nextChunkText
]

{ #category : #accessing }
PqHelp class >> pages [
	^#(introduction links)
]
