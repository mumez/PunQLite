pages
pageUsages1
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