pages
pageUsages4
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