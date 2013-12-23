jx9
compileFile: jx9SrcPath into: outVm on: dbHandle
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	^ self nbCall: #( int unqlite_compile_file( db_ptr dbHandle, String jx9SrcPath, vm_ptr* outVm) ) module: #unqlite
	