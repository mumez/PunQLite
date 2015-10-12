initialization
initializeMenu

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