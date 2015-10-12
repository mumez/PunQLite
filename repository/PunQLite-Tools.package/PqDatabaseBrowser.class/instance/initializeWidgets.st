initialization
initializeWidgets

	self initializeMenu.
	keysModel := self instantiate: IconListModel.
	keysModel 
			menu: [:aMenu | self keysListMenu: aMenu];
	 		whenSelectionChanged: [ self onKeySelectionChanged ].
	valueModel := self newText.
	self focusOrder add: valueModel