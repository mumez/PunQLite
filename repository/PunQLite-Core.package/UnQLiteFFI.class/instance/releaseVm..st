jx9
releaseVm: vmHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_vm_release( vm_ptr vmHandle) ) module: #unqlite
	