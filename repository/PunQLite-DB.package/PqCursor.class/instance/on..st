initialize-release
on: aDatabase
	self database: aDatabase.
	self prepareHandle.
	handleIsValid := self isOk: (ffi initCursor: self handle db: self dbHandle).