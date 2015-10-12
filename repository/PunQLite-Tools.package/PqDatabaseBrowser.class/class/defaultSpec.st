private - specs
defaultSpec
	<spec>
	
	^ SpecLayout composed
		newColumn: [ :c | 
			c 
				add: #menu height: self toolbarHeight;
				add: self contentSpec ];	
		yourself