"
I represent the abstract base class for all PunQLite objects that manage native UnQLite handles.

Responsibility:
- Manage lifecycle of native FFI handles (ExternalAddress instances)
- Track handle validity state to prevent use-after-free errors
- Provide template method pattern for resource cleanup (#release, #freeResources)
- Define common settings access (fetch buffer size, configuration)
- Provide shared utilities for byte array conversion and return code checking
- Ensure proper initialization of handle state in subclass instances

Collaborators:
- UnQLiteFFI: Accessed via #ffi for making all low-level FFI calls
- PqSettings: Provides configuration defaults (fetch buffer sizes)
- UnQLiteConstants: Pool providing return code constants (OK, DONE)
- ExternalAddress: Represents native C pointers (database, cursor, VM handles)
- Subclasses (PqDatabase, PqCursor, PqJx9Executer): Override #release for specific cleanup

Public API and Key Messages:
- #ffi - Access UnQLiteFFI singleton for FFI calls
- #settings - Get or create PqSettings for this instance
- #fetchBufferSize, #fetchBufferSize: - Control buffer allocation for FFI fetch operations
- #prepareHandle - Allocate new ExternalAddress for FFI calls
- #freeResources - Public cleanup method, calls #release then frees handle
- #release - Subclass hook for native resource cleanup (must override)
- #isOk:, #isDone: - Check FFI return codes against constants

Internal Representation:
- handle - ExternalAddress pointing to native C structure (db*, cursor*, vm*)
- handleIsValid - Boolean tracking whether handle is open/usable
- fetchBufferSize - Integer controlling buffer allocation (default from settings)
- settings - PqSettings instance for configuration

Implementation Points:
- Subclasses must override #release to perform specific cleanup (e.g., ffi close: handle)
- #freeResources wraps #release in ensure block to guarantee handle cleanup
- Handle is set to null after #freeResources to prevent dangling pointers
- #prepareHandle lazily creates ExternalAddress when needed
- #toByteArray: utility converts Strings to UTF-8 ByteArrays for FFI calls
- Return code checking (#isOk:, #isDone:) uses UnQLiteConstants pool
- Settings are lazily initialized to PqSettings default singleton
- Always call #freeResources or #close (which delegates to it) to prevent leaks
"
Class {
	#name : 'PqObject',
	#superclass : 'Object',
	#instVars : [
		'handle',
		'handleIsValid',
		'fetchBufferSize',
		'settings'
	],
	#pools : [
		'UnQLiteConstants'
	],
	#category : 'PunQLite-Core-Base',
	#package : 'PunQLite-Core',
	#tag : 'Base'
}

{ #category : 'accessing' }
PqObject >> fetchBufferSize [
	^ fetchBufferSize ifNil: [fetchBufferSize := self settings defaultFetchBufferSize]
]

{ #category : 'accessing' }
PqObject >> fetchBufferSize: anObject [
	fetchBufferSize := anObject
]

{ #category : 'accessing' }
PqObject >> ffi [
	^ UnQLiteFFI uniqueInstance 
]

{ #category : 'initialize-release' }
PqObject >> freeResources [
	(handle isNil or: [ handle isNull ]) 
		ifTrue: [ ^ self ].
	
	[self release]
 	ensure: [
		handle free.
		handle beNull ]
]

{ #category : 'accessing' }
PqObject >> handle [
	^ handle
]

{ #category : 'initialize-release' }
PqObject >> initialize [
	super initialize.
	handleIsValid := false.

]

{ #category : 'testing' }
PqObject >> isDone: returnCode [
	^ returnCode = DONE
]

{ #category : 'testing' }
PqObject >> isOk: returnCode [
	^ returnCode = OK
]

{ #category : 'initialize-release' }
PqObject >> prepareHandle [
	^ handle ifNil: [ handle := ExternalAddress new ]
]

{ #category : 'initialize-release' }
PqObject >> release [
	
]

{ #category : 'accessing' }
PqObject >> settings [
	^ settings ifNil: [settings := PqSettings default]
]

{ #category : 'accessing' }
PqObject >> settings: aPqSettings [
	settings := aPqSettings
]

{ #category : 'private' }
PqObject >> toByteArray: anObject [

	^ anObject isString 
		ifTrue: [ anObject utf8Encoded ]
		ifFalse: [ anObject ]
]
