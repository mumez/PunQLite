jx9
intFrom: pValue
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_value_to_int( value_ptr pValue) ) module: #unqlite