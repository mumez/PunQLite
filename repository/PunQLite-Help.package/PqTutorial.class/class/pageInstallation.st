pages
pageInstallation
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