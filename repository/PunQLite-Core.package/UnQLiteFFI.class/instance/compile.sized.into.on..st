jx9
compile: jx9 sized: sz into: outVm on: dbHandle
	^ self ffiCall: #( int unqlite_compile( db_ptr dbHandle, String jx9, int sz,  vm_ptr* outVm) )