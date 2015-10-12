menu
menuCommandOn: aBuilder

	<worldMenu>		 
		
	(aBuilder item: #'Database Browser')
		parent: #'PunQLite';
		order: 1;
		action:[ self open ]; 
		icon: self taskbarIcon.