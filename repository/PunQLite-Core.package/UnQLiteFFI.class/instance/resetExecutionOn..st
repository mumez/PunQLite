jx9
resetExecutionOn: vmHandle
	^ self ffiCall: #( int unqlite_vm_reset( vm_ptr vmHandle) )