jx9
doubleFrom: pValue
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( double unqlite_value_to_double( value_ptr pValue) ) module: #unqlite