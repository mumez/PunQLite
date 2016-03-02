jx9
newStructure: vmHandle
	^ self ffiCall: #( value_ptr unqlite_vm_new_array(vm_ptr vmHandle) )