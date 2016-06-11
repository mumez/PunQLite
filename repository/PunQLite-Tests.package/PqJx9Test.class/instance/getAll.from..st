private
getAll: collectionName from: db
	| records |
	db jx9Do: [ :executor | | result | 
		executor compile: ('$result = db_fetch_all("{1}")' format: { collectionName }).
		executor execute.
		result := executor extract: 'result'.
		records := result asArray ].
	^ records