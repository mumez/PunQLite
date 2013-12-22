class initialization
initialize
	"self initialize"
	
	IntHolderType := (NBExternalTypeValue ofType: 'NBInt64').
	StringHolderType := (NBExternalTypeValue ofType: 'char*').
	
	self initializeTypeMap.