actions
fetchAt: key into: aBlock

	| wrappedBlock |
	wrappedBlock := [:dataAddr :dataSize :userData | | ret |
		ret := OK.
		[| data |
			data := ByteArray new: dataSize.
			LibC memCopy: dataAddr to: data size: dataSize.
			aBlock cull: data cull: userData
		] on: Error do: [:ex | ret := ABORT]. 
		ret
	].

	^self fetchAt: key basicInto: wrappedBlock