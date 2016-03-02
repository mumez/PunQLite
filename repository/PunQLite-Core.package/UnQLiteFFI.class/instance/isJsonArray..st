jx9 - testing
isJsonArray: pValue
	^ self ffiCall: #( int unqlite_value_is_json_array(value_ptr pValue) )