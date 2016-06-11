class initialization
initializeTypeMap
	"self initializeTypeMap"
	<script>
	
	TypeMap := Dictionary newFromPairs: #(
		db_ptr 			#'void *'
		cursor_ptr 		#'void *'
		vm_ptr    		#'void *'
		value_ptr 		#'void *'
		context_ptr 		#'void *'
		
		char_ptr 			String
		buf_out 			ByteArray

		int64_t 			int64
		bufSize_holder 	IntHolderType
		buf_holder 		StringHolderType
	)