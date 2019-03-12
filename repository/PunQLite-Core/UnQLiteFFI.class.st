"
FFI interface to the UnQLite shared library
"
Class {
	#name : #UnQLiteFFI,
	#superclass : #Object,
	#classVars : [
		'IntHolderType',
		'StringHolderType',
		'TypeMap'
	],
	#pools : [
		'UnQLiteConstants'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'PunQLite-Core-FFI'
}

{ #category : #factory }
UnQLiteFFI class >> ffiBindingOf: aTypeName [
	^ TypeMap at: aTypeName ifAbsent: [ super ffiBindingOf: aTypeName ]
]

{ #category : #'class initialization' }
UnQLiteFFI class >> initialize [
	"self initialize"
	
	IntHolderType :=  FFIExternalValueHolder ofType: 'int'.
	StringHolderType := FFIExternalValueHolder ofType: 'char*'.
	
	self initializeTypeMap.
]

{ #category : #'class initialization' }
UnQLiteFFI class >> initializeTypeMap [
	"self initializeTypeMap"
	<script>
	
	TypeMap := Dictionary newFromPairs: #(
		db_ptr 			#'void *'
		cursor_ptr 		#'void *'
		vm_ptr    		#'void *'
		value_ptr 		#'void *'
		context_ptr 		#'void *'
		
		char_ptr 			String
		buf_out 			ByteArray

		int64_t 			int64
		bufSize_holder 	IntHolderType
		buf_holder 		StringHolderType
	)
]

{ #category : #'instance creation' }
UnQLiteFFI class >> new [
	self error: 'Use #uniqueInstance'
]

{ #category : #factory }
UnQLiteFFI class >> newIntHolder [
	^IntHolderType new
]

{ #category : #factory }
UnQLiteFFI class >> newIntHolder: anInteger [
	| holder |
	holder := self newIntHolder.
	holder value: anInteger.
	^holder
]

{ #category : #factory }
UnQLiteFFI class >> newStringHolder [
	^StringHolderType new
]

{ #category : #'instance creation' }
UnQLiteFFI class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := super new ]
]

{ #category : #actions }
UnQLiteFFI >> append: dbHandle key: key sized: keySize value: value sized: valueSize [
	^ self ffiCall: #( int unqlite_kv_append( db_ptr dbHandle, void* key, int keySize, void* value, int64_t valueSize) )
]

{ #category : #'jx9 - accessing' }
UnQLiteFFI >> array: pArray walk: xWalk data: pUserData [
	self ffiCall: #( int unqlite_array_walk(
      value_ptr pArray,
      FFICallback xWalk,
      void *pUserData) )
]

{ #category : #transactions }
UnQLiteFFI >> beginTransactionOn: dbHandle [
	^ self ffiCall: #( int unqlite_begin( db_ptr dbHandle) )
]

{ #category : #'jx9 - conversion' }
UnQLiteFFI >> boolFrom: pValue [
	^ self ffiCall: #( int unqlite_value_to_bool( value_ptr pValue) )
]

{ #category : #jx9 }
UnQLiteFFI >> clearValue: pValue [
	^ self ffiCall: #( int unqlite_value_null( value_ptr pValue) )
]

{ #category : #actions }
UnQLiteFFI >> close: dbHandle [
	^ self ffiCall: #( int unqlite_close( db_ptr dbHandle) )
]

{ #category : #transactions }
UnQLiteFFI >> commitTransactionOn: dbHandle [
	^ self ffiCall: #( int unqlite_commit( db_ptr dbHandle) )
]

{ #category : #jx9 }
UnQLiteFFI >> compile: jx9 sized: sz into: outVm on: dbHandle [
	^ self ffiCall: #( int unqlite_compile( db_ptr dbHandle, String jx9, int sz,  vm_ptr* outVm) )
]

{ #category : #jx9 }
UnQLiteFFI >> compileFile: jx9SrcPath into: outVm on: dbHandle [
	^ self ffiCall: #( int unqlite_compile_file( db_ptr dbHandle, String jx9SrcPath, vm_ptr* outVm) )
]

{ #category : #configuration }
UnQLiteFFI >> config: dbHandle command: commandId [
	^ self ffiCall: #( int unqlite_config( db_ptr dbHandle, int commandId) )
]

{ #category : #configuration }
UnQLiteFFI >> config: dbHandle command: commandId buffer: buffer [
	^ self ffiCall: #( int unqlite_config( db_ptr dbHandle, int commandId, buf_holder buffer) )
]

{ #category : #configuration }
UnQLiteFFI >> config: dbHandle command: commandId buffer: buffer sized: bufferSize [
	^ self ffiCall: #( int unqlite_config( db_ptr dbHandle, int commandId, buf_holder buffer, int* bufferSize) )
]

{ #category : #configuration }
UnQLiteFFI >> configVM: vmHandle addVar: valueObject named: varName [
	"For some weird reason, the function unqlite_vm_config receives a va_list as argument, and 
	 marshaling of char* is doing something weird. 
	 I workaround the problem by passing a ByteArray"
	^ self 
		primConfigVM: vmHandle 
		addVar: valueObject 
		named: (varName asByteArray copyWith: 0)
]

{ #category : #actions }
UnQLiteFFI >> delete: dbHandle key: key sized: keySize [
	^self ffiCall: #( int unqlite_kv_delete( db_ptr dbHandle, void* key, int keySize) )
]

{ #category : #'actions-cursor' }
UnQLiteFFI >> deleteEntryOn: cursorHandle [
	^ self ffiCall: #( int unqlite_kv_cursor_delete_entry(cursor_ptr cursorHandle) )
]

{ #category : #'jx9 - conversion' }
UnQLiteFFI >> doubleFrom: pValue [
	^ self ffiCall: #( double unqlite_value_to_double( value_ptr pValue) )
]

{ #category : #jx9 }
UnQLiteFFI >> executeOn: vmHandle [
	^ self ffiCall: #( int unqlite_vm_exec( vm_ptr vmHandle) )
]

{ #category : #jx9 }
UnQLiteFFI >> extract: varName on: vmHandle [
	^ self ffiCall: #( value_ptr unqlite_vm_extract_variable( vm_ptr vmHandle, String varName) )
]

{ #category : #actions }
UnQLiteFFI >> fetch: dbHandle key: key sized: keySize callback: callback [
	^ self ffiCall: #( int unqlite_kv_fetch_callback( db_ptr dbHandle, void* key, int keySize, UnQLiteFetchCallback callback, 0) ) options: #( optMayGC )
]

{ #category : #actions }
UnQLiteFFI >> fetch: dbHandle key: key sized: keySize callback: callback userData: userData [
	^ self ffiCall: #( int unqlite_kv_fetch_callback( db_ptr dbHandle, void* key, int keySize, UnQLiteFetchCallback callback, void* userData) )
]

{ #category : #actions }
UnQLiteFFI >> fetch: dbHandle key: key sized: keySize value: value sized: valueSize [
	^ self ffiCall: #( int unqlite_kv_fetch( db_ptr dbHandle, void* key, int keySize, void* value, bufSize_holder valueSize) )
]

{ #category : #private }
UnQLiteFFI >> ffiLibraryName [
	^ UnQLiteLibrary
]

{ #category : #'actions-cursor' }
UnQLiteFFI >> firstEntryOn: cursorHandle [
	^ self ffiCall: #( int unqlite_kv_cursor_first_entry(cursor_ptr cursorHandle) )
]

{ #category : #utilities }
UnQLiteFFI >> getRandomNumber: dbHandle [
	^ self ffiCall: #( int unqlite_util_random_num( db_ptr dbHandle) )
]

{ #category : #utilities }
UnQLiteFFI >> getRandomString: dbHandle into: value sized: valueSize [
	^ self ffiCall: #( int unqlite_util_random_string( db_ptr dbHandle, char* value, uint valueSize) )
]

{ #category : #'actions-cursor' }
UnQLiteFFI >> initCursor: cursorHandle db: dbHandle [
	^ self ffiCall: #( int unqlite_kv_cursor_init(db_ptr dbHandle, cursor_ptr* cursorHandle))
]

{ #category : #'jx9 - conversion' }
UnQLiteFFI >> int64From: pValue [
	^ self ffiCall: #( int64 unqlite_value_to_int64( value_ptr pValue) )
]

{ #category : #'jx9 - init/release' }
UnQLiteFFI >> intFrom: pValue [
	^ self ffiCall: #( int unqlite_value_to_int( value_ptr pValue ) )
]

{ #category : #'jx9 - testing' }
UnQLiteFFI >> isBool: pValue [
	^ self ffiCall: #( int unqlite_value_is_bool(value_ptr pValue) )
]

{ #category : #'jx9 - testing' }
UnQLiteFFI >> isFloat: pValue [
	^ self ffiCall: #( int unqlite_value_is_float(value_ptr pValue) )
]

{ #category : #'jx9 - testing' }
UnQLiteFFI >> isInt: pValue [
	^ self ffiCall: #( int unqlite_value_is_int(value_ptr pValue) )
]

{ #category : #'jx9 - testing' }
UnQLiteFFI >> isJsonArray: pValue [
	^ self ffiCall: #( int unqlite_value_is_json_array(value_ptr pValue) )
]

{ #category : #'jx9 - testing' }
UnQLiteFFI >> isJsonObject: pValue [
	^ self ffiCall: #( int unqlite_value_is_json_object(value_ptr pValue) )
]

{ #category : #'jx9 - testing' }
UnQLiteFFI >> isNull: pValue [
	^ self ffiCall: #( int unqlite_value_is_null(value_ptr pValue) )
]

{ #category : #'jx9 - testing' }
UnQLiteFFI >> isNumeric: pValue [
	^ self ffiCall: #( int unqlite_value_is_numeric(value_ptr pValue) )
]

{ #category : #'jx9 - testing' }
UnQLiteFFI >> isResource: pValue [
	^ self ffiCall: #( int unqlite_value_is_resource(value_ptr pValue) )
]

{ #category : #'jx9 - testing' }
UnQLiteFFI >> isScalar: pValue [
	^ self ffiCall: #( int unqlite_value_is_scalar(value_ptr pValue) )
]

{ #category : #'jx9 - testing' }
UnQLiteFFI >> isString: pValue [
	^ self ffiCall: #( int unqlite_value_is_string(value_ptr pValue) )
]

{ #category : #'actions-cursor' }
UnQLiteFFI >> isValidEntryOn: cursorHandle [
	^ self ffiCall: #( int unqlite_kv_cursor_valid_entry(cursor_ptr cursorHandle) )
]

{ #category : #'actions-cursor' }
UnQLiteFFI >> key: key sized: keySize on: cursorHandle [
	^ self ffiCall: #( int unqlite_kv_cursor_key( cursor_ptr cursorHandle, void* key, bufSize_holder keySize) )
]

{ #category : #'actions-cursor' }
UnQLiteFFI >> keyByCallback: callback on: cursorHandle [ 
	^ self 
		ffiCall: #( int unqlite_kv_cursor_key_callback( cursor_ptr cursorHandle, UnQLiteFetchCallback callback, 0) ) 
		options: #( optMayGC )
]

{ #category : #'actions-cursor' }
UnQLiteFFI >> keyByCallback: callback userData: userData on: cursorHandle [ 
	^ self 
		ffiCall: #( int unqlite_kv_cursor_key_callback( cursor_ptr cursorHandle, UnQLiteFetchCallback callback, void* userData) ) 
		options: #( optMayGC )
]

{ #category : #'actions-cursor' }
UnQLiteFFI >> lastEntryOn: cursorHandle [
	^ self ffiCall: #( int unqlite_kv_cursor_last_entry(cursor_ptr cursorHandle) )
]

{ #category : #utilities }
UnQLiteFFI >> loadMmapedFile: fileMap path: filePath sized: fileSize [
	^ self ffiCall: #( int unqlite_util_load_mmaped_file ( String filePath, buf_holder fileMap, bufSize_holder fileSize ) )
]

{ #category : #jx9 }
UnQLiteFFI >> newFunction: pVm name: zName callback: xFunc data: pUserData [
	"xFunc needs to be the thunk of an FFICallback"
	^ self ffiCall: #( int unqlite_create_function(vm_ptr pVm, char *zName, void *xFunc, void *pUserData) )
]

{ #category : #jx9 }
UnQLiteFFI >> newScalar: vmHandle [
	^ self ffiCall: #( value_ptr unqlite_vm_new_scalar(vm_ptr vmHandle) )
]

{ #category : #jx9 }
UnQLiteFFI >> newStructure: vmHandle [
	^ self ffiCall: #( value_ptr unqlite_vm_new_array(vm_ptr vmHandle) )
]

{ #category : #'actions-cursor' }
UnQLiteFFI >> nextEntryOn: cursorHandle [
	^ self ffiCall: #( int unqlite_kv_cursor_next_entry(cursor_ptr cursorHandle) )
]

{ #category : #actions }
UnQLiteFFI >> open: dbHandle named: dbName mode: mode [
	^ self ffiCall: #( int unqlite_open( db_ptr* dbHandle, String dbName, uint mode) )
]

{ #category : #'actions-cursor' }
UnQLiteFFI >> previousEntryOn: cursorHandle [
	^ self ffiCall: #( int unqlite_kv_cursor_prev_entry(cursor_ptr cursorHandle) )
]

{ #category : #private }
UnQLiteFFI >> primConfigVM: vmHandle addVar: valueObject named: varName [
	^ self ffiCall: #( int unqlite_vm_config(vm_ptr vmHandle, VM_CONFIG_CREATE_VAR, char *varName, value_ptr valueObject) )
]

{ #category : #'actions-cursor' }
UnQLiteFFI >> releaseCursor: cursorHandle db: dbHandle [
	^ self ffiCall: #( int unqlite_kv_cursor_release(db_ptr dbHandle, cursor_ptr cursorHandle) )
]

{ #category : #utilities }
UnQLiteFFI >> releaseMmapedFile: fileMap sized: fileSize [
	^ self ffiCall: #( int unqlite_util_release_mmaped_file( void* fileMap, int64_t fileSize) )
]

{ #category : #'jx9 - init/release' }
UnQLiteFFI >> releaseValue: valueHandle vm: vmHandle [
	^ self ffiCall: #( int unqlite_vm_release_value(vm_ptr vmHandle, value_ptr valueHandle) )
]

{ #category : #'jx9 - init/release' }
UnQLiteFFI >> releaseVm: vmHandle [
	^ self ffiCall: #( int unqlite_vm_release( vm_ptr vmHandle) )
]

{ #category : #'actions-cursor' }
UnQLiteFFI >> resetCursor: cursorHandle [
	^ self ffiCall: #( int unqlite_kv_cursor_reset( cursor_ptr cursorHandle ) )
]

{ #category : #jx9 }
UnQLiteFFI >> resetExecutionOn: vmHandle [
	^ self ffiCall: #( int unqlite_vm_reset( vm_ptr vmHandle) )
]

{ #category : #jx9 }
UnQLiteFFI >> resetStringCursor: pVal [
	^ self ffiCall: #( int unqlite_value_reset_string_cursor( value_ptr pVal ) )
]

{ #category : #'jx9 - conversion' }
UnQLiteFFI >> resourceFrom: pValue [
	^ self ffiCall: #( void *unqlite_value_to_resource( value_ptr pValue ) )
]

{ #category : #'jx9 - result' }
UnQLiteFFI >> result: pCtx boolean: iBool [
	^ self ffiCall: #(int unqlite_result_bool(context_ptr pCtx, bool iBool))
]

{ #category : #'jx9 - result' }
UnQLiteFFI >> result: pCtx double: dValue [
	^ self ffiCall: #(unqlite_result_double(context_ptr pCtx, double dValue))
]

{ #category : #'jx9 - result' }
UnQLiteFFI >> result: pCtx int64: iValue [
	^ self ffiCall: #(unqlite_result_int64(context_ptr pCtx, int64 iValue))
]

{ #category : #'jx9 - result' }
UnQLiteFFI >> result: pCtx int: iValue [
	^ self ffiCall: #(unqlite_result_int(context_ptr pCtx, int iValue))
]

{ #category : #'jx9 - result' }
UnQLiteFFI >> result: pCtx resource: pUserData [
	^ self ffiCall: #(unqlite_result_resource(context_ptr pCtx, void *pUserData))
]

{ #category : #'jx9 - result' }
UnQLiteFFI >> result: pCtx string: zString [
	^ self ffiCall: #(unqlite_result_string(context_ptr pCtx, String zString))
]

{ #category : #'jx9 - result' }
UnQLiteFFI >> result: pCtx value: pValue [
	^ self ffiCall: #(unqlite_result_value(context_ptr pCtx, value_ptr pValue))
]

{ #category : #'jx9 - result' }
UnQLiteFFI >> resultNull: pCtx [
	^ self ffiCall: #(unqlite_result_null(context_ptr pCtx))
]

{ #category : #transactions }
UnQLiteFFI >> rollbackTransactionOn: dbHandle [
	^ self ffiCall: #( int unqlite_rollback( db_ptr dbHandle) )
]

{ #category : #'actions-cursor' }
UnQLiteFFI >> seekKey: key sized: keySize on: cursorHandle by: seekPosition [
	^ self ffiCall: #( int unqlite_kv_cursor_seek( cursor_ptr cursorHandle, void* key, int keySize, int seekPosition) )
]

{ #category : #'jx9 - accessing' }
UnQLiteFFI >> setValue: pValue boolean: anObject [
	^ self ffiCall: #( int unqlite_value_bool( value_ptr pValue, int anObject) )
]

{ #category : #'jx9 - accessing' }
UnQLiteFFI >> setValue: pValue double: aFloat [
	^ self ffiCall: #( int unqlite_value_double( value_ptr pValue, double aFloat) )
]

{ #category : #'jx9 - accessing' }
UnQLiteFFI >> setValue: pValue int64: anInteger [
	^ self ffiCall: #( int unqlite_value_int64( value_ptr pValue, int64_t anInteger) )
]

{ #category : #'jx9 - accessing' }
UnQLiteFFI >> setValue: pValue int: anInteger [
	^ self ffiCall: #( int unqlite_value_int( value_ptr pValue, int anInteger) )
]

{ #category : #'jx9 - accessing' }
UnQLiteFFI >> setValue: pValue resource: pUserData [
	^ self ffiCall: #( int unqlite_value_resource( value_ptr pValue, void *pUserData) )
]

{ #category : #'jx9 - accessing' }
UnQLiteFFI >> setValue: pValue string: anObject [
	^ self ffiCall: #( int unqlite_value_string( value_ptr pValue, String anObject, -1) )
]

{ #category : #actions }
UnQLiteFFI >> store: dbHandle key: key sized: keySize value: value sized: valueSize [
	^ self ffiCall: #( int unqlite_kv_store( db_ptr dbHandle, void* key, int keySize, void* value, int64_t valueSize) )
]

{ #category : #'jx9 - conversion' }
UnQLiteFFI >> stringFrom: pValue [
	^ self ffiCall: #( String unqlite_value_to_string( value_ptr pValue, 0) )
]

{ #category : #'jx9 - accessing' }
UnQLiteFFI >> structure: structHandle atKey: key putValue: valueHandle [
	^ self ffiCall: #( int unqlite_array_add_strkey_elem(value_ptr structHandle, String key, value_ptr valueHandle) )
]

{ #category : #'jx9 - accessing' }
UnQLiteFFI >> structure: structHandle atPosition: positionHandle putValue: valueHandle [
	^ self ffiCall: #( int unqlite_array_add_elem(value_ptr structHandle, value_ptr positionHandle, value_ptr valueHandle) )
]

{ #category : #'jx9 - accessing' }
UnQLiteFFI >> structureCount: structHandle [
	^ self ffiCall: #( int unqlite_array_count(value_ptr structHandle) )
]

{ #category : #'actions-cursor' }
UnQLiteFFI >> value: value sized: valueSize on: cursorHandle [
	^ self ffiCall: #( int unqlite_kv_cursor_data( cursor_ptr cursorHandle, void* value, bufSize_holder valueSize) )
]

{ #category : #'actions-cursor' }
UnQLiteFFI >> valueByCallback: callback on: cursorHandle [
	^ self ffiCall: #( int unqlite_kv_cursor_data_callback( cursor_ptr cursorHandle, UnQLiteFetchCallback callback, 0) ) options: #( optMayGC )
]

{ #category : #'actions-cursor' }
UnQLiteFFI >> valueByCallback: callback userData: userData on: cursorHandle [
	^ self ffiCall: #( int unqlite_kv_cursor_data_callback( cursor_ptr cursorHandle, UnQLiteFetchCallback callback, void* userData) ) options: #( optMayGC )
]
