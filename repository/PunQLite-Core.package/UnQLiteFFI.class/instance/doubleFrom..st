jx9 - conversion
doubleFrom: pValue
	^ self ffiCall: #( double unqlite_value_to_double( value_ptr pValue) )