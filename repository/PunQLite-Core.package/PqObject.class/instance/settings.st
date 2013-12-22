accessing
settings
	^ settings ifNil: [settings := PqSettings default]