configuration
configVM: vmHandle addVar: valueObject named: varName
	^ self ffiCall: #( int unqlite_vm_config(vm_ptr vmHandle, VM_CONFIG_CREATE_VAR	, String varName, value_ptr valueObject) )