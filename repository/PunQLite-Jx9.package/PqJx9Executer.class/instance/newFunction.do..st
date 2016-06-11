factory
newFunction: aString do: aBlock
	"installs functions into a jx9 vm. 
	 aBlock will receive a parameter who will be the result of evaluating the record (usually, 
	 this will be a JSON dictionary).
	 aBlock MUST answer a valid Jx9 answer (something that can be answered with unqlite_result_* 
	 functions)"
	| callback |

	callback := FFICallback 
		signature: #(int (void *pCtx, int argc, void **argv)) 
		block:  [ :ctx :argc :argv | | record |
			record := (PqJx9Value named: nil on: (argv pointerAt: 1)) value.
			self 
				result: (aBlock value: record)
				onContext: (PqJx9Context fromHandle: ctx).
			OK ].
	self registerCallback: callback name: aString.
	^ self isOk: (UnQLiteFFI uniqueInstance 
		newFunction: self handle
		name: aString 
		callback: callback thunk
		data: ExternalAddress null).