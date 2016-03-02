jx9 - accessing
structure: structHandle atPosition: positionHandle putValue: valueHandle
	^ self ffiCall: #( int unqlite_array_add_elem(value_ptr structHandle, value_ptr positionHandle, value_ptr valueHandle) )