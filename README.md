PunQLite 
========

[UnQLite](https://unqlite.symisc.net/ "UnQLite") binding for [Pharo Smalltalk](http://pharo.org/ "Pharo").
UnQLite is a fast, lightweight, portable, embedded KVS with a simple scripting engine (Jx9). By using PunQLite, you can store/load lots of data as if just using a normal Dictionary.

[![Release](https://img.shields.io/github/v/tag/mumez/PunQLite?label=release)](https://github.com/mumez/PunQLite/releases)
[![License](https://img.shields.io/badge/license-MIT-green)](./LICENSE.txt)

[![Social](https://img.shields.io/github/stars/mumez/PunQLite?style=social)]()
[![Forks](https://img.shields.io/github/forks/mumez/PunQLite?style=sociall)]()

Directories:

- repository
  - [Tonel](https://github.com/pharo-vcs/tonel) style Smalltalk source tree

## Installation

### Step 1: Prepare UnQLite Library

You need to prepare the UnQLite shared library. UnQLite is very easy to compile - it consists of only **two files** (`unqlite.c` and `unqlite.h`). You have two options:

**Option A: Download Pre-built Binaries (Recommended)**

Download the pre-built library for your platform:

- [Linux AMD64](https://github.com/mumez/PunQLite/releases/download/v3.0.0/unqlite.so)
- [MacOS ARM64](https://github.com/mumez/PunQLite/releases/download/v3.0.0/unqlite.dylib)
- [Windows x64](https://github.com/mumez/PunQLite/releases/download/v3.0.0/unqlite.dll)

Place the downloaded library in your Pharo image directory.

**Option B: Build from Source**

If you prefer, you can build the UnQLite library by yourself:

1. Download the UnQLite source code from [UnQLite repository](https://github.com/symisc/unqlite)

2. Compile the library for your platform:

**Linux:**
```bash
gcc -c unqlite.c
gcc -shared -o unqlite.so unqlite.o
```

**macOS:**
```bash
gcc -c unqlite.c
gcc -dynamiclib -o unqlite.dylib unqlite.o
```

**Windows (MinGW):**
```bash
gcc -c unqlite.c
gcc -shared -static-libgcc -o unqlite.dll unqlite.o
```

**Note:** For 32-bit systems, add the `-m32` option to both gcc commands.

3. Place the compiled library (`unqlite.so`, `unqlite.dylib`, or `unqlite.dll`) in your Pharo image directory.

### Step 2: Load PunQLite

```Smalltalk
Metacello new
	repository: 'github://mumez/PunQLite/repository';
	baseline: 'PunQLite';
	load.
```

## Usages ##
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
(FileSystem workingDirectory / 'pharo-local' / 'package-cache') files do: [:each | 
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
executer release.
db close.
```

## Performance ##
```Smalltalk
"Simple store/load round-trip"
Time millisecondsToRun:[
db := PqDatabase open: 'bench.db'.
val := '0'.
1 to: 100000 do: [:idx | | key | 
	key := idx asString.
	db at: key put: val.
	val := (db at: key) asString.
].
db close.
]. "===> 877 msecs"
```
I felt it is quite fast. 100000 round-trips in 877 msecs. Please try the code by yourself.
