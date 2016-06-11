configuration
configVM: vmHandle addVar: valueObject named: varName
	"For some weird reason, the function unqlite_vm_config receives a va_list as argument, and 
	 marshaling of char* is doing something weird. 
	 I workaround the problem by passing a ByteArray"
	^ self 
		primConfigVM: vmHandle 
		addVar: valueObject 
		named: (varName asByteArray copyWith: 0)