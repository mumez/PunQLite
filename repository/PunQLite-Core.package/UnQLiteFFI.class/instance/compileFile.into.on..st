jx9
compileFile: jx9SrcPath into: outVm on: dbHandle
	^ self ffiCall: #( int unqlite_compile_file( db_ptr dbHandle, String jx9SrcPath, vm_ptr* outVm) )