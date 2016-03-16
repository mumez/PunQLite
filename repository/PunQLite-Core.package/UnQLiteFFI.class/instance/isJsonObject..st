jx9 - testing
isJsonObject: pValue
	^ self ffiCall: #( int unqlite_value_is_json_object(value_ptr pValue) )