private - menues
keysListMenu: aMenu

	aMenu target: self.
	aMenu addTitle:  'Entry'.
	aMenu add: 'Add entry' selector: #onAddSelectedEntry.			 
	keysModel selectedItem ifNotNil: [ 
		aMenu add: 'Remove entry' selector: #onRemoveSelectedEntry.		
	].
	aMenu addLine.
	aMenu add: 'Edit entry' selector: #onEditEntry.
	^aMenu