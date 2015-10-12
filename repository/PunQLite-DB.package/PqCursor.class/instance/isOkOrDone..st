testing
isOkOrDone: returnCode
	^ (self isOk: returnCode) or: [ returnCode = DONE]