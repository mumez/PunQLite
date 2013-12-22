PunQLite
========

[UnQLite](http://unqlite.org "UnQLite") binding for [Pharo Smalltalk](http://www.pharo-project.org/ "Pharo").
UnQLite is a fast, lightweight, portable, embedded KVS with a simple scripting engine (Jx9). By using PunQLite, you can store/load lots of data as if just using normal Dictionary.

Directories:

- binary
 + pre-build shared libraries (unqlite.dll, bundle, so, etc)
- repository
 + [Cypress](https://github.com/CampSmalltalk/Cypress) style Smalltalk source tree

For MCZ packages, visit [SmalltalkHub PunQLite site](http://smalltalkhub.com/#!/~MasashiUmezawa/PunQLite).

## Installation ##
1. Compile UnQLite
It would be very easy, but I also put pre-build binaries for some platforms, so please just download them if you have no time to compile.

2. Load PunQLite
```Smalltalk
Gofer new
      url: 'http://smalltalkhub.com/mc/MasashiUmezawa/PunQLite/main';
      package: 'ConfigurationOfPunQLite';
      load.
(Smalltalk at: #ConfigurationOfPunQLite) load
```
The final target will be Pharo 3.0. But Pharo 2.0 would also work.



## Performance ##
```Smalltalk
"Simple store/load round-trip"
Time millisecondsToRun:[
db := PqDatabase open: 'bench.db'.
prev := '0'.
1 to: 100000 do: [:idx | | key | 
	key := idx asString.
	db at: key put: prev.
	prev := (db at: key) asString.
].
db close.
]. "===> 877 msecs"
```
I felt it is quite fast. Please try by yourself.

## Usage ##
```Smalltalk
"Like a Dictionary"
db := PqDatabase openOnMemory.
db at: 'Smalltalk' put: 'COOL'.
db at: 'Pharo' put: 'HOT'.
db at: 'Smalltalk' ifPresent: [:data |
	data asString inspect
].
Transcript cr; show: db keys.
db do: [:cursor |
	Transcript cr; show: cursor currentStringKey; space; show: cursor currentStringValue.		
].
db close.

```
```Smalltalk
"Using explicit transaction"
db := PqDatabase open: 'trans.db'.
db disableAutoCommit.
1 to: 100 do: [:idx | | key | 
	key := idx asString.
	db transact: [db at: key put: ('value-', key)]
].
db close.
```
```Smalltalk
"Using cursor seek"
db := PqDatabase openOnMemory.
1 to: 10 do: [:idx |
	db at: idx asString put: 'value-', idx asString.
].
cursor := db newCursor.
entries := OrderedCollection new.
cursor seek: '5' untilEndDo: [:cur |
	entries add: (cur currentStringKey -> cur currentStringValue)	
].
cursor close.
db close.
^entries "==> an OrderedCollection('5'->'value-5' '6'->'value-6' '7'->'value-7' '8'->'value-8' '9'->'value-9' '10'->'value-10')"
```
```Smalltalk
"Import from files"
db := PqDatabase open: 'mczCache.db'.
(FileSystem workingDirectory / 'package-cache') files do: [:each | 
	(db importAt: each basename fromFile: each pathString)
		 ifTrue: [db commitTransaction].
].
db keys inspect.
db close.
```
```Smalltalk
"Excute Jx9 scripting language"
db := PqDatabase openOnMemory.
src := '
	$var = 123;
	$str = "$var - one, two, three!";
	$tm = time();
	'.
executer := db jx9.
executer evaluate: src.
(executer extract: 'var') asInt inspect.
(executer extract: 'str') asString inspect. 
(executer extract: 'tm') asInt inspect.
db close.
```