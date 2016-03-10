class initialization
initializeTypeMap
	"self initializeTypeMap"
	<script>
	
	TypeMap := Dictionary newFromPairs: #(
		db_ptr 			FFIExternalObject
		cursor_ptr 		FFIExternalObject
		vm_ptr    		FFIExternalObject
		value_ptr 		FFIExternalObject
		
		char_ptr 			FFIExternalString
		buf_out 			ByteArray

		int64_t 			FFIInt64
		bufSize_holder 	IntHolderType
		buf_holder 		StringHolderType
	)