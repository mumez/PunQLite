pages
pageUsages3
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