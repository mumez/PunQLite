catalog
catalogKeyClassesAndExample

	^ 'It is composed of some keys classes: 
		
- ==PqDatabase== represents a database. You can open a DB and put/get values like a dictionary.
		
- ==PqCursor== is an iterator on a database. You can jump to the specific point by seek:. 

Example:
[[[ 
db := PqDatabase openOnMemory.
db at: ''Smalltalk'' put: ''COOL''.
db at: ''Pharo' put: 'HOT''.
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