accessing
at: aKey put: aValue
	| value result |
	
	value := aValue jx9ValueOn: self executer.
	result := self ffi structure: self handle atKey: aKey putValue: value handle.
	"if value is the same object that came, we let the user to release (It happens if user 
	 sent a PqJx9Value)"
	value == aValue 
		ifFalse: [ self executer release: value ].
	^ result
	