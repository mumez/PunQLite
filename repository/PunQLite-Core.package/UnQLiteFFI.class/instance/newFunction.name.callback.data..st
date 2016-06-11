jx9
newFunction: pVm name: zName callback: xFunc data: pUserData
	"xFunc needs to be the thunk of an FFICallback"
	^ self ffiCall: #( int unqlite_create_function(vm_ptr pVm, char *zName, void *xFunc, void *pUserData) )