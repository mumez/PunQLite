jx9 - init/release
releaseValue: valueHandle vm: vmHandle
	^ self ffiCall: #( int unqlite_vm_release_value(vm_ptr vmHandle, value_ptr valueHandle) )