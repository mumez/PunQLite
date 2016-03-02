jx9
newScalar: vmHandle
	^ self ffiCall: #( value_ptr unqlite_vm_new_scalar(vm_ptr vmHandle) )