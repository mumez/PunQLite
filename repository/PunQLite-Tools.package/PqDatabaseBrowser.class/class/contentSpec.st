private - specs
contentSpec 
 	<spec: #content>
 
	^SpecLayout composed
		  newRow: [:row |  
					row add: self leftSpec;
					addSplitter;
					add:  #valueModel ] 