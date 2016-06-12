enumerating
select: aBlock
	"Answer all documents that matches aBlock
	 NOTE: Since I have a potential different select each time, I need to create a different 
	 executor. This is probably a very naive approach, but is the easiest I have for now :) "
	| executor |
	executor := self jx9Select.
	[
		executor newFunction: 'filter' do: aBlock.
		executor execute.
		^ (executor extract: 'records') asArray ]
	ensure: [ executor release ]