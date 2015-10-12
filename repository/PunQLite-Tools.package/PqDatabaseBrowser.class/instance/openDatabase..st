private - utilities
openDatabase: filename

 
	database := PqDatabase open: filename.
	databaseFilename := filename.
	self updateKeysModel.

	self updateTitle.