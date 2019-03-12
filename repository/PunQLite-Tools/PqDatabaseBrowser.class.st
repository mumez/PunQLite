"
A database browser

Instance Variables
	menu:		<Object>

menu
	- xxxxx

"
Class {
	#name : #PqDatabaseBrowser,
	#superclass : #ComposableModel,
	#instVars : [
		'database',
		'keysModel',
		'menu',
		'valueModel',
		'databaseFilename'
	],
	#category : 'PunQLite-Tools-UI'
}

{ #category : #'private - specs' }
PqDatabaseBrowser class >> contentSpec [ 
 	<spec: #content>
 
	^SpecLayout composed
		  newRow: [:row |  
					row add: self leftSpec;
					addSplitter;
					add:  #valueModel ] 
]

{ #category : #'private - specs' }
PqDatabaseBrowser class >> defaultSpec [
	<spec>
	
	^ SpecLayout composed
		newColumn: [ :c | 
			c 
				add: #menu height: self toolbarHeight;
				add: self contentSpec ];	
		yourself
]

{ #category : #examples }
PqDatabaseBrowser class >> example1 [

	self open
]

{ #category : #'private - specs' }
PqDatabaseBrowser class >> leftSpec [
  	<spec>
 
	| searchBarOffset delta |
	searchBarOffset := 5 + StandardFonts defaultFont height + 10.
	delta := 25.
	^SpecLayout composed 
		add: #keysModel origin: 0@0 corner: 1@1 offsetOrigin: 0@searchBarOffset offsetCorner: 0@0;
		add: #keysSearchField origin: 0@0 corner: 1@0 offsetOrigin: 0@0 offsetCorner: 0@searchBarOffset
]

{ #category : #menu }
PqDatabaseBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>		 
		
	(aBuilder item: #'Database Browser')
		parent: #'PunQLite';
		order: 1;
		action:[ self open ]; 
		icon: self taskbarIcon.
]

{ #category : #'instance creation' }
PqDatabaseBrowser class >> open [
	<script>
	
	^(self new)  
		openWithSpec;
		yourself
]

{ #category : #menu }
PqDatabaseBrowser class >> taskbarIcon [

	^PqToolIcons iconNamed: #databaseConnectIcon
]

{ #category : #accessing }
PqDatabaseBrowser >> database [

	^database
]

{ #category : #'private - events' }
PqDatabaseBrowser >> delete [

	database ifNotNil: [ database close. databaseFile := nil ].
	super delete.
]

{ #category : #initialization }
PqDatabaseBrowser >> initialExtent [

	^600@460
]

{ #category : #initialization }
PqDatabaseBrowser >> initializeMenu [

	menu := MenuModel new
		addGroup: [ :group |			 
			group addItem: [ :item |
				item
					name: nil;
					description: 'Open file';
					icon: (PqToolIcons iconNamed: #databaseConnectIcon);
					action: [ self openFile ] ].
				
			group addItem: [ :item |
				item
					name: nil;
					description: 'Edit entry';
					icon: (PqToolIcons iconNamed: #databaseEditIcon);
					action: [ self onEditEntry ] ].				

			group addItem: [ :item |
				item
					name: nil;
					description: 'Add entry';
					icon: (PqToolIcons iconNamed: #databaseAddIcon);
					action: [ self onAddEntry ] ].				   
			 
			group addItem: [ :item |
				item
					name: nil;
					description: 'Remove entry';
					icon: (PqToolIcons iconNamed: #databaseRemoveIcon);
					action: [ self onRemoveSelectedEntry ]].	
								
			group addItem: [ :item |
				item 
					name: nil;
					description: 'Help';
					icon: Smalltalk ui icons smallHelpIcon;
					action: [ self openHelp ] ].		
		].
		
	menu applyTo: self.
]

{ #category : #initialization }
PqDatabaseBrowser >> initializeWidgets [

	self initializeMenu.
	keysModel := self instantiate: IconListModel.
	keysModel 
			menu: [:aMenu | self keysListMenu: aMenu];
	 		whenSelectionChanged: [ self onKeySelectionChanged ].
	valueModel := self newText.
	self focusOrder add: valueModel
]

{ #category : #'private - filtering' }
PqDatabaseBrowser >> keysFilterPattern: aRxMatcher [ 
	 
	 self keysModel items: 
		(aRxMatcher isNil ifTrue: [self database keys ]
					    ifFalse: [ self database keys select: [ :each| aRxMatcher search: each asString ]]).

	 
]

{ #category : #'private - menues' }
PqDatabaseBrowser >> keysListMenu: aMenu [

	aMenu target: self.
	aMenu addTitle:  'Entry'.
	aMenu add: 'Add entry' selector: #onAddSelectedEntry.			 
	keysModel selectedItem ifNotNil: [ 
		aMenu add: 'Remove entry' selector: #onRemoveSelectedEntry.		
	].
	aMenu addLine.
	aMenu add: 'Edit entry' selector: #onEditEntry.
	^aMenu
]

{ #category : #accessing }
PqDatabaseBrowser >> keysModel [

	^keysModel
]

{ #category : #accessing }
PqDatabaseBrowser >> keysModel: anObject [

	keysModel := anObject
]

{ #category : #'private - filtering' }
PqDatabaseBrowser >> keysSearchAccept: aString [

	 aString isEmptyOrNil
		ifTrue: [ self keysFilterPattern: nil ]
		ifFalse: [ self keysFilterPattern: 
					([ aString asRegexIgnoringCase ] on: RegexSyntaxError do: [ aString ])].
 
]

{ #category : #'private - filtering' }
PqDatabaseBrowser >> keysSearchField [

	^ (SearchMorph new)
			model: self;
			setIndexSelector: #keysSearchAccept:; 
			updateSelector: #keysSearchAccept:;
			searchList: #();
			asSpecAdapter
]

{ #category : #accessing }
PqDatabaseBrowser >> menu [
	^ menu
]

{ #category : #accessing }
PqDatabaseBrowser >> menu: anObject [
	menu := anObject
]

{ #category : #'private - actions' }
PqDatabaseBrowser >> onAddEntry [
	|key value |
	self database ifNil: [ ^self ].
	
	key := UIManager default request: 'New key' initialAnswer: ''.
	key ifNil: [ ^self ]. 

	value := UIManager default request: 'New value' initialAnswer: ''.
	value ifNil: [ ^self ].
	
	self database notNil ifTrue: [
		self database transact: [
			self database at: key put: value.
		].
		self updateKeysModel ]
]

{ #category : #'private - actions' }
PqDatabaseBrowser >> onEditEntry [
	|key value |
	self database ifNil: [ ^self ].
	
	key := self keysModel selectedItem.
	key ifNil: [ ^self ].
	
	value := UIManager default request: 'New value for ', key initialAnswer: (database at: key).
	value ifNil: [ ^self ].
	
	self database notNil ifTrue: [
		self database transact: [
			self database at: key put: value.
		].
		self updateValueModel ]
]

{ #category : #'private - events' }
PqDatabaseBrowser >> onKeySelectionChanged [
	self updateValueModel
]

{ #category : #'private - actions' }
PqDatabaseBrowser >> onRemoveSelectedEntry [

	self database notNil ifTrue: [
		self database transact: [
			self database removeKey: self keysModel selectedItem.
			self keysModel resetSelection ].
		self updateKeysModel ]
]

{ #category : #'private - utilities' }
PqDatabaseBrowser >> openDatabase: filename [

 
	database := PqDatabase open: filename.
	databaseFilename := filename.
	self updateKeysModel.

	self updateTitle.
]

{ #category : #'private - actions' }
PqDatabaseBrowser >> openFile [
    | filename |
    filename := UITheme builder 
                            fileOpen: 'Choose a .db file' 
                            extensions: #('db').
    filename isNil ifTrue:[ ^self ].
    self openDatabase: filename name
]

{ #category : #'private - actions' }
PqDatabaseBrowser >> openHelp [

	HelpBrowser openOn: PqHelp asHelpTopic 
]

{ #category : #accessing }
PqDatabaseBrowser >> title [

	^databaseFilename ifNil: [ 'PUnQLite browser' ]
		ifNotNil: [ databaseFilename  ]
]

{ #category : #'private - updating' }
PqDatabaseBrowser >> updateKeysModel [

	keysModel items: database keys sorted
]

{ #category : #'private - updating' }
PqDatabaseBrowser >> updateValueModel [

	|key|
	key := self keysModel selectedItem.
	key 
		ifNil: [ self valueModel text: '' ] 
		ifNotNil: [ self valueModel text: (self database at: key) asString ]
]

{ #category : #accessing }
PqDatabaseBrowser >> valueModel [
	^ valueModel
]

{ #category : #accessing }
PqDatabaseBrowser >> valueModel: anObject [
	valueModel := anObject
]
