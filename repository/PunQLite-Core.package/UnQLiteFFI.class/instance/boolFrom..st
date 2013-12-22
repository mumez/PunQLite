jx9
boolFrom: pValue
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_value_to_bool( value_ptr pValue) ) module: #unqlite