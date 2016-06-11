accessing
add: aValue
	| result value |
	
	value := aValue jx9ValueOn: self executer.
	result := self isOk: (self ffi 
		structure: self handle 
		atPosition: ExternalAddress null "Auto assign position"
		putValue: value handle).
	"if value is the same object that came, we let the user to release (It happens if user 
	 sent a PqJx9Value)"
	value == aValue 
		ifFalse: [ self executer release: value ].
	^ result 