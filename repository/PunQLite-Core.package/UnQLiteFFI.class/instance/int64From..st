jx9
int64From: pValue
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( NBInt64 unqlite_value_to_int64( value_ptr pValue) ) module: #unqlite