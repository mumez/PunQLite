jx9 - accessing
structure: structHandle atKey: key putValue: valueHandle
	^ self ffiCall: #( int unqlite_array_add_strkey_elem(value_ptr structHandle, String key, value_ptr valueHandle) )