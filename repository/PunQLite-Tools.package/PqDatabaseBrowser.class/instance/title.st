accessing
title

	^databaseFilename ifNil: [ 'PUnQLite browser' ]
		ifNotNil: [ databaseFilename  ]