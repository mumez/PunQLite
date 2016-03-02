jx9 - conversion
stringFrom: pValue
	^ self ffiCall: #( String unqlite_value_to_string( value_ptr pValue, 0) )