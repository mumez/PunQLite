private
getById: aNumber from: db
	| records |
	
	db jx9Do: [ :executor | | result |
		executor compile: '$result = db_fetch_all("users", query)'.
		executor newFunction: 'query' do: [ :rec | (rec at: '__id') = aNumber ].
		executor execute.
		result := executor extract: 'result'.
		result isJsonArray 
			ifTrue: [ records := result asArray ]
			ifFalse: [ ^ nil ] ].
		
	^ records first
		