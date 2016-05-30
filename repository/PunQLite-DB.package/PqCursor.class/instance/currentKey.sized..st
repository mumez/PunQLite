accessing key
currentKey: outKey sized: keySizeHolder
	^self ffi 
		key: outKey 
		sized: keySizeHolder 
		on: self handle