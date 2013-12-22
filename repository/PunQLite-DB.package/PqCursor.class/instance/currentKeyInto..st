accessing key
currentKeyInto: aBlock
	| wrappedBlock |
	wrappedBlock := [:dataAddr :dataSize :userData | | ret |
		ret := UnQLiteConstants OK.
		[| data |
			data := ByteArray new: dataSize.
			NativeBoost memCopy: dataAddr to: data size: dataSize.
			aBlock cull: data cull: userData
		] on: Error do: [:ex | ret := UnQLiteConstants ABORT]. 
		ret
	].
	^self currentKeyBasicInto: wrappedBlock