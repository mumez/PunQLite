jx9
compile: jx9 sized: sz into: outVm on: dbHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_compile( db_ptr dbHandle, String jx9, int sz,  vm_ptr* outVm) ) module: #unqlite