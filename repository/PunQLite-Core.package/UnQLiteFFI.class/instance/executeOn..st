jx9
executeOn: vmHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_vm_exec( vm_ptr vmHandle) ) module: #unqlite