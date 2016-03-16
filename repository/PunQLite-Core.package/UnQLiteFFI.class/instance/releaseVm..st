jx9 - init/release
releaseVm: vmHandle
	^ self ffiCall: #( int unqlite_vm_release( vm_ptr vmHandle) )