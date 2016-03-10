class initialization
initialize
	"self initialize"
	
	IntHolderType :=  FFIExternalValueHolder ofType: 'int'.
	StringHolderType := FFIExternalValueHolder ofType: 'char*'.
	
	self initializeTypeMap.