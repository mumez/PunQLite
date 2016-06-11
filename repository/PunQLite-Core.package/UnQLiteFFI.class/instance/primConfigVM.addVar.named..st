private
primConfigVM: vmHandle addVar: valueObject named: varName
	^ self ffiCall: #( int unqlite_vm_config(vm_ptr vmHandle, VM_CONFIG_CREATE_VAR, char *varName, value_ptr valueObject) )