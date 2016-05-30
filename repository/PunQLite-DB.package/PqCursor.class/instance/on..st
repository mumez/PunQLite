initialize-release
on: aDatabase
	self database: aDatabase.
	self prepareHandle.
	handleIsValid := self isOk: (self ffi initCursor: self handle db: self dbHandle).