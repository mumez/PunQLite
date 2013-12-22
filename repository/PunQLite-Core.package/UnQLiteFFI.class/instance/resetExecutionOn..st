jx9
resetExecutionOn: vmHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_vm_reset( vm_ptr vmHandle) ) module: #unqlite