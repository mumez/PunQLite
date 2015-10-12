pages
pageUsages2
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