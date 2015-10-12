private - events
delete

	database ifNotNil: [ database close. databaseFile := nil ].
	super delete.