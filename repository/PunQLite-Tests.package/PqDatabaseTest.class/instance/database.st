accessing
database
	^ database ifNil: [ database := PqDatabase openOnMemory ]