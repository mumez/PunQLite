accessing
size
	"Answer the size of current collection (# of records)"
	| executor |
	
	self flag: #fixMe. "For some reason, caching the executor for gettings records is 
	 not working (it answers always first value, even if size changes. 
	 So for now I'm not caching it..."
	executor := self jx9Size.
	[ 
		executor execute.
		^ (executor extract: 'result') value ]
	ensure: [ executor release ]