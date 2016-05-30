accessig value
currentValue: outValue sized: valueSize
	^self ffi 
		value: outValue 
		sized: valueSize 
		on: self handle