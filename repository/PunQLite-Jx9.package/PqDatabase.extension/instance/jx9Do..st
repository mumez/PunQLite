*PunQlite-Jx9
jx9Do: aBlock
	| jx9 |
	[jx9 := self jx9.
	aBlock value: jx9
	] ensure: [jx9 ifNotNil: [jx9 release]]