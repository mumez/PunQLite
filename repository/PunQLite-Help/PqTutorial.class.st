"
This is a custom help book providing a tutorial for the PqLite database framework.

"
Class {
	#name : #PqTutorial,
	#superclass : #PqHelp,
	#category : 'PunQLite-Help'
}

{ #category : #accessing }
PqTutorial class >> bookName [
	^'Tutorial'
]

{ #category : #pages }
PqTutorial class >> pageInstallation [
	"This method was automatically generated."
	<script: 'self edit: #pageInstallation'>
	^HelpTopic
		title: 'Installation'
		contents: 
'Compile UnQLite
It would be very easy. UnQLite consists of only two files.

    gcc -m32 -c unqlite.c

#linux
    gcc -m32 -shared -o unqlite.so unqlite.o

#win (MinGW)
    gcc -m32 -shared -o unqlite.dll unqlite.o -Wl,--add-stdcall-alias

#mac
    gcc -m32 -dynamiclib -o unqlite.dylib unqlite.o

However, There are also pre-built binaries for common platforms, so please just download them if you have no time to compile (see links section)!' readStream nextChunkText
]

{ #category : #pages }
PqTutorial class >> pagePerformance [
	"This method was automatically generated."
	<script: 'self edit: #pagePerformance'>
	^HelpTopic
		title: 'Performance'
		contents: 
'"Simple store/load round-trip"
	Time millisecondsToRun:[
	db := PqDatabase open: ''bench.db''.
	val := ''0''.
	1 to: 100000 do: [:idx | | key | 
	    key := idx asString.
	    db at: key put: val.
	    val := (db at: key) asString.
	].
	db close.

	]. "===> 877 msecs"


I felt it is quite fast. 100000 round-trips in 877 msecs. Please try the code by yourself.!' readStream nextChunkText
]

{ #category : #pages }
PqTutorial class >> pageUsages1 [
	"This method was automatically generated."
	<script: 'self edit: #pageUsages1'>
	^HelpTopic
		title: 'Usages 1'
		contents: 
'"Like a Dictionary"
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
db close.!' readStream nextChunkText
]

{ #category : #pages }
PqTutorial class >> pageUsages2 [
	"This method was automatically generated."
	<script: 'self edit: #pageUsages2'>
	^HelpTopic
		title: 'Usages 2'
		contents: 
'"Using explicit transaction"
db := PqDatabase open: ''trans.db''.
db disableAutoCommit.
1 to: 100 do: [:idx | | key | 
    key := idx asString.
    db transact: [db at: key put: (''value-'', key)]
].
db close.!' readStream nextChunkText
]

{ #category : #pages }
PqTutorial class >> pageUsages3 [
	"This method was automatically generated."
	<script: 'self edit: #pageUsages3'>
	^HelpTopic
		title: 'Usages 3'
		contents: 
'"Using cursor seek"
db := PqDatabase openOnMemory.
1 to: 10 do: [:idx |
    db at: idx asString put: ''value-'', idx asString.
].
cursor := db newCursor.
entries := OrderedCollection new.
cursor seek: ''5'' untilEndDo: [:cur |
    entries add: (cur currentStringKey -> cur currentStringValue)   
].
cursor close.
db close.
^entries "==> an OrderedCollection(''5''->''value-5'' ''6''->''value-6'' ''7''->''value-7'' ''8''->''value-8'' ''9''->''value-9'' ''10''->''value-10'')"!' readStream nextChunkText
]

{ #category : #pages }
PqTutorial class >> pageUsages4 [
	"This method was automatically generated."
	<script: 'self edit: #pageUsages4'>
	^HelpTopic
		title: 'Usages 4'
		contents: 
'"Import from files"
db := PqDatabase open: ''mczCache.db''.
(FileSystem workingDirectory / ''package-cache'') files do: [:each | 
    (db importAt: each basename fromFile: each pathString)
         ifTrue: [db commitTransaction].
].
db keys inspect.
db close.!' readStream nextChunkText
]

{ #category : #pages }
PqTutorial class >> pageUsages5 [
	"This method was automatically generated."
	<script: 'self edit: #pageUsages5'>
	^HelpTopic
		title: 'Usages 5'
		contents: 
'"Excute Jx9 scripting language"
db := PqDatabase openOnMemory.
src := ''
    $var = 123;
    $str = "$var - one, two, three!!";
    $tm = time();
    ''.
executer := db jx9.
executer evaluate: src.
(executer extract: ''var'') asInt inspect.
(executer extract: ''str'') asString inspect. 
(executer extract: ''tm'') asInt inspect.
executer release.
db close.!' readStream nextChunkText
]

{ #category : #accessing }
PqTutorial class >> pages [
	^#(pageInstallation pagePerformance pageUsages1 pageUsages2 pageUsages3 pageUsages4 pageUsages5)
]
