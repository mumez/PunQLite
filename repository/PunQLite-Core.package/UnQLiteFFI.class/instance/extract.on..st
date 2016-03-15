jx9
extract: varName on: vmHandle
	^ self ffiCall: #( value_ptr unqlite_vm_extract_variable( vm_ptr vmHandle, String varName) )