jx9
stringFrom: pValue
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( String unqlite_value_to_string( value_ptr pValue, 0) ) module: #unqlite