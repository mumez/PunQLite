jx9 - accessing
array: pArray walk: xWalk data: pUserData
	self ffiCall: #( int unqlite_array_walk(
      value_ptr pArray,
      FFICallback xWalk,
      void *pUserData) )