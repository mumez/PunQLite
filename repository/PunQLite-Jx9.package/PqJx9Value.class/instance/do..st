enumerating
do: aBlock 
	"if value is JSON array, this will work"
	ffi 
		array: self handle
		walk: (FFICallback
			signature: #(int (void *pKey, void *pValue, void *pUserData))  
			block: [ :key :value :data | 
				aBlock value: (PqJx9Value named: nil on: (FFIExternalObject new setHandle: value)). 
				OK ])
		data: nil
