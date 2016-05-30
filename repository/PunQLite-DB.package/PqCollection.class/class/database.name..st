instance creation
database: aDatabase name: aString
	^ self basicNew 
		initializeDatabase: aDatabase name: aString;
		yourself