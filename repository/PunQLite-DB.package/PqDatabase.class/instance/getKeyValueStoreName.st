system-info
getKeyValueStoreName
	|  strOut |
	strOut := UnQLiteFFI newStringHolder.
	ffi config: self handle command: CONFIG_GET_KV_NAME buffer: strOut.
	^strOut value readString