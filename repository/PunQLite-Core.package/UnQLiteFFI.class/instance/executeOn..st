jx9
executeOn: vmHandle
	^ self ffiCall: #( int unqlite_vm_exec( vm_ptr vmHandle) )