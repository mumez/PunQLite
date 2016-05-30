enumerating
keysAndValuesDo: aBlock 
	"if value is JSON array/object, this will work"
	self ffi 
		array: self handle
		walk: (FFICallback
			signature: #(int (void *pKey, void *pValue, void *pUserData))  
			block: [ :key :value :data | 
				aBlock 
					value: (PqJx9Value named: nil on: key)
					value: (PqJx9Value named: nil on: value). 
				OK ])
		data: nil
