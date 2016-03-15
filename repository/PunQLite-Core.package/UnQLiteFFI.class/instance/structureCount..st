jx9 - accessing
structureCount: structHandle
	^ self ffiCall: #( int unqlite_array_count(value_ptr structHandle) )