"
A shared pool with UnQLite defined constants
"
Class {
	#name : 'UnQLiteConstants',
	#superclass : 'SharedPool',
	#classVars : [
		'ABORT',
		'BUSY',
		'CANTOPEN',
		'COMPILE_ERR',
		'CONFIG_DISABLE_AUTO_COMMIT',
		'CONFIG_ERR_LOG',
		'CONFIG_GET_KV_NAME',
		'CONFIG_JX9_ERR_LOG',
		'CONFIG_KV_ENGINE',
		'CONFIG_MAX_PAGE_CACHE',
		'CORRUPT',
		'CURSOR_MATCH_EXACT',
		'CURSOR_MATCH_GE',
		'CURSOR_MATCH_LE',
		'DONE',
		'EMPTY',
		'EOF',
		'EXISTS',
		'FULL',
		'INVALID',
		'IOERR',
		'KV_CONFIG_CMP_FUNC',
		'KV_CONFIG_HASH_FUNC',
		'LIMIT',
		'LOCKED',
		'LOCKERR',
		'NOMEM',
		'NOOP',
		'NOTFOUND',
		'NOTIMPLEMENTED',
		'OK',
		'OPEN_CREATE',
		'OPEN_EXCLUSIVE',
		'OPEN_IN_MEMORY',
		'OPEN_MMAP',
		'OPEN_NOMUTEX',
		'OPEN_OMIT_JOURNALING',
		'OPEN_READONLY',
		'OPEN_READWRITE',
		'OPEN_TEMP_DB',
		'PERM',
		'READ_ONLY',
		'UNKNOWN',
		'VM_CONFIG_ARGV_ENTRY',
		'VM_CONFIG_CREATE_VAR',
		'VM_CONFIG_ENV_ATTR',
		'VM_CONFIG_ERR_REPORT',
		'VM_CONFIG_EXEC_VALUE',
		'VM_CONFIG_EXTRACT_OUTPUT',
		'VM_CONFIG_HTTP_REQUEST',
		'VM_CONFIG_IMPORT_PATH',
		'VM_CONFIG_IO_STREAM',
		'VM_CONFIG_OUTPUT',
		'VM_CONFIG_RECURSION_DEPTH',
		'VM_CONFIG_SERVER_ATTR',
		'VM_ERR',
		'VM_OUTPUT_LENGTH'
	],
	#category : 'PunQLite-Core-FFI',
	#package : 'PunQLite-Core',
	#tag : 'FFI'
}

{ #category : 'private - initialization' }
UnQLiteConstants class >> initBaseConstants [

	OK := 0
]

{ #category : 'private - initialization' }
UnQLiteConstants class >> initConfigConstants [

	CONFIG_JX9_ERR_LOG := 1.
	CONFIG_MAX_PAGE_CACHE := 2.
	CONFIG_ERR_LOG := 3.
	CONFIG_KV_ENGINE := 4.
	CONFIG_DISABLE_AUTO_COMMIT := 5.
	CONFIG_GET_KV_NAME := 6.
	
	KV_CONFIG_HASH_FUNC := 1.
	KV_CONFIG_CMP_FUNC := 2
	
]

{ #category : 'private - initialization' }
UnQLiteConstants class >> initCursorConstants [
		
	CURSOR_MATCH_EXACT := 1.
	CURSOR_MATCH_LE := 2.
	CURSOR_MATCH_GE := 3.
	
]

{ #category : 'private - initialization' }
UnQLiteConstants class >> initErrorConstants [
		LOCKERR := -76.
		READ_ONLY := -75.

		CANTOPEN := -74.
		FULL := -73.
		VM_ERR := -71.
		COMPILE_ERR := -70.

		DONE := -28.
		CORRUPT := -24.
		PERM := -19.
		EOF := -18.
		NOTIMPLEMENTED := -17.
      BUSY := -14.
		UNKNOWN := -13.

		EXISTS := -11.
		ABORT := -10.
		INVALID := -9.
		LIMIT := -7.
		LOCKED := -4.
		EMPTY := -3.
		IOERR := -2.
		NOMEM := -1.
		NOOP := -20.
		NOTFOUND := -6
		
		
		
		
		
		
]

{ #category : 'private - initialization' }
UnQLiteConstants class >> initJx9Constants [

		VM_CONFIG_OUTPUT := 1.
		VM_CONFIG_IMPORT_PATH := 2.
		VM_CONFIG_ERR_REPORT := 3.
		VM_CONFIG_RECURSION_DEPTH := 4.
		VM_OUTPUT_LENGTH := 5.
		VM_CONFIG_CREATE_VAR := 6.
		VM_CONFIG_HTTP_REQUEST := 7.
		VM_CONFIG_SERVER_ATTR := 8.
		VM_CONFIG_ENV_ATTR := 9.
		VM_CONFIG_EXEC_VALUE := 10.
		VM_CONFIG_IO_STREAM := 11.
		VM_CONFIG_ARGV_ENTRY := 12.
		VM_CONFIG_EXTRACT_OUTPUT := 13
]

{ #category : 'private - initialization' }
UnQLiteConstants class >> initOpenConstants [

	OPEN_READONLY := 1.
	OPEN_READWRITE := 2.
	OPEN_CREATE := 4.
	OPEN_EXCLUSIVE := 8.
	OPEN_IN_MEMORY := 80.
	OPEN_MMAP := 100.
	OPEN_NOMUTEX := 20.
	OPEN_OMIT_JOURNALING := 40.
	OPEN_TEMP_DB := 10
]

{ #category : 'initialization' }
UnQLiteConstants class >> initialize [

	self 
		initBaseConstants;
		initConfigConstants;
		initOpenConstants;
		initCursorConstants;
		initErrorConstants;
		initJx9Constants
		
]
