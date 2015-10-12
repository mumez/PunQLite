system-info
getErrorLog
	|  strOut intOut |
	strOut := UnQLiteFFI newStringHolder.
	intOut := UnQLiteFFI newIntHolder.
	ffi config: self handle command: CONFIG_ERR_LOG buffer: strOut sized: intOut.
	^strOut value readString