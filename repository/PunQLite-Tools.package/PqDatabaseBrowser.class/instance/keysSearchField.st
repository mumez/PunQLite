private - filtering
keysSearchField

	^ (SearchMorph new)
			model: self;
			setIndexSelector: #keysSearchAccept:; 
			updateSelector: #keysSearchAccept:;
			searchList: #();
			asSpecAdapter