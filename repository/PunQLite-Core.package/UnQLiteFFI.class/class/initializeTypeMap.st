class initialization
initializeTypeMap
	"self initializeTypeMap"
	<script>
	
	TypeMap := Dictionary newFromPairs: #(
		db_ptr NBExternalObject
		cursor_ptr  NBExternalObject
		vm_ptr    NBExternalObject
		value_ptr    NBExternalAddress
		
		char_ptr           NBExternalString
		buf_out			ByteArray

		int64_t           NBInt64
	).
	
	TypeMap at: #bufSize_holder put: IntHolderType.
	TypeMap at: #buf_holder put: StringHolderType
	