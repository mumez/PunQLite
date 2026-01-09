"
A database browser for PunQLite

Instance Variables
	database:			<PqDatabase> The database being browsed
	keysList:			<SpFilteringListPresenter> List of keys with filter
	toolbar:			<SpToolbarPresenter> Toolbar with action buttons
	valueText:			<SpTextPresenter> Text display for selected value
	databaseFilename:	<String> Path to opened database file

"
Class {
	#name : #PqDatabaseBrowser,
	#superclass : #SpPresenter,
	#instVars : [
		'database',
		'keysList',
		'toolbar',
		'valueText',
		'databaseFilename'
	],
	#category : 'PunQLite-Tools-UI'
}

{ #category : #examples }
PqDatabaseBrowser class >> example1 [
	<example>

	self open
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

	^ self new open
]

{ #category : #menu }
PqDatabaseBrowser class >> taskbarIcon [

	^ PqToolIcons iconNamed: #databaseConnectIcon
]

{ #category : #accessing }
PqDatabaseBrowser >> database [

	^ database
]

{ #category : #layout }
PqDatabaseBrowser >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: #toolbar withConstraints: [ :c | c height: self class toolbarHeight ];
		add: (SpPanedLayout newLeftToRight
			add: #keysList;
			add: #valueText;
			yourself);
		yourself
]

{ #category : #initialization }
PqDatabaseBrowser >> initializePresenters [

	self initializeToolbar.

	keysList := self instantiate: SpFilteringListPresenter.
	keysList
		items: #();
		display: [ :item | item ];
		matchSubstring;
		contextMenu: [ self keysListContextMenu ];
		whenSelectionChangedDo: [ :selection | self onKeySelectionChanged ].

	valueText := self newText.
	valueText editable: false
]

{ #category : #initialization }
PqDatabaseBrowser >> initializeToolbar [

	toolbar := self newToolbar.

	toolbar add: (SpToolbarButtonPresenter new
		label: 'Open';
		icon: (PqToolIcons iconNamed: #databaseConnectIcon);
		help: 'Open database file';
		action: [ self openFile ];
		yourself).

	toolbar add: (SpToolbarButtonPresenter new
		label: 'Edit';
		icon: (PqToolIcons iconNamed: #databaseEditIcon);
		help: 'Edit entry';
		action: [ self onEditEntry ];
		yourself).

	toolbar add: (SpToolbarButtonPresenter new
		label: 'Add';
		icon: (PqToolIcons iconNamed: #databaseAddIcon);
		help: 'Add entry';
		action: [ self onAddEntry ];
		yourself).

	toolbar add: (SpToolbarButtonPresenter new
		label: 'Remove';
		icon: (PqToolIcons iconNamed: #databaseRemoveIcon);
		help: 'Remove entry';
		action: [ self onRemoveSelectedEntry ];
		yourself)
]

{ #category : #initialization }
PqDatabaseBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self title;
		initialExtent: 600@460;
		whenClosedDo: [ self onWindowClosed ]
]

{ #category : #accessing }
PqDatabaseBrowser >> keysList [

	^ keysList
]

{ #category : #'private - menus' }
PqDatabaseBrowser >> keysListContextMenu [

	^ self newMenu
		addItem: [ :item |
			item
				name: 'Add entry';
				action: [ self onAddEntry ] ];
		addItem: [ :item |
			item
				name: 'Remove entry';
				enabled: [ keysList selectedItem isNotNil ];
				action: [ self onRemoveSelectedEntry ] ];
		addItem: [ :item |
			item
				name: 'Edit entry';
				enabled: [ keysList selectedItem isNotNil ];
				action: [ self onEditEntry ] ];
		yourself
]

{ #category : #'private - actions' }
PqDatabaseBrowser >> onAddEntry [
	| key value |

	self database ifNil: [ ^ self ].

	key := UIManager default request: 'New key' initialAnswer: ''.
	key ifNil: [ ^ self ].

	value := UIManager default request: 'New value' initialAnswer: ''.
	value ifNil: [ ^ self ].

	self database ifNotNil: [
		self database transact: [
			self database at: key put: value ].
		self updateKeysList ]
]

{ #category : #'private - actions' }
PqDatabaseBrowser >> onEditEntry [
	| key value |

	self database ifNil: [ ^ self ].

	key := keysList selectedItem.
	key ifNil: [ ^ self ].

	value := UIManager default
		request: 'New value for ', key
		initialAnswer: (self database at: key).
	value ifNil: [ ^ self ].

	self database ifNotNil: [
		self database transact: [
			self database at: key put: value ].
		self updateValueText ]
]

{ #category : #'private - events' }
PqDatabaseBrowser >> onKeySelectionChanged [

	self updateValueText
]

{ #category : #'private - actions' }
PqDatabaseBrowser >> onRemoveSelectedEntry [

	self database ifNotNil: [
		self database transact: [
			self database removeKey: keysList selectedItem.
			keysList unselectAll ].
		self updateKeysList ]
]

{ #category : #'private - events' }
PqDatabaseBrowser >> onWindowClosed [

	self database ifNotNil: [
		self database close.
		database := nil.
		databaseFilename := nil ]
]

{ #category : #'private - utilities' }
PqDatabaseBrowser >> openDatabase: aFilename [

	database := PqDatabase open: aFilename.
	databaseFilename := aFilename.
	self updateKeysList.
	self updateTitle
]

{ #category : #'private - actions' }
PqDatabaseBrowser >> openFile [
	| fileReference |

	fileReference := UIManager default
		chooseExistingFileReference: 'Choose a .db file'
		extensions: #('db')
		path: FileLocator home.

	fileReference ifNotNil: [
		self openDatabase: fileReference fullName ]
]

{ #category : #accessing }
PqDatabaseBrowser >> title [

	^ databaseFilename
		ifNil: [ 'PunQLite browser' ]
		ifNotNil: [ databaseFilename  ]
]

{ #category : #accessing }
PqDatabaseBrowser >> toolbar [

	^ toolbar
]

{ #category : #'private - updating' }
PqDatabaseBrowser >> updateKeysList [

	keysList items: self database keys sorted
]

{ #category : #'private - updating' }
PqDatabaseBrowser >> updateTitle [

	self withWindowDo: [ :window | window title: self title ]
]

{ #category : #'private - updating' }
PqDatabaseBrowser >> updateValueText [
	| key |

	key := keysList selectedItem.
	key
		ifNil: [ valueText text: '' ]
		ifNotNil: [ valueText text: (self database at: key) asString ]
]

{ #category : #accessing }
PqDatabaseBrowser >> valueText [

	^ valueText
]
