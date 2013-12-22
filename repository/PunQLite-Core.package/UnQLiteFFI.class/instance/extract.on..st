jx9
extract: varName on: vmHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( NBExternalAddress unqlite_vm_extract_variable( vm_ptr vmHandle, String varName) ) module: #unqlite