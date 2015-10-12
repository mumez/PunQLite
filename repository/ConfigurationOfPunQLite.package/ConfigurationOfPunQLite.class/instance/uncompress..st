private - utilities
uncompress: fileRef
	| dst zipArchive |
	dst := FileSystem workingDirectory / 'pharo-vm'.
	(fileRef fullName endsWith: '.zip')
		ifFalse: [ self error: 'Cannot extract library from file: ' , fileRef printString ].
	[ zipArchive := ZipArchive new.
	zipArchive readFrom: fileRef fullName.
	UIManager default informUserDuring: [ :bar | zipArchive extractAllTo: dst informing: bar overwrite: true ] ]
		ensure: [ zipArchive ifNotNil: [zipArchive close]].
	fileRef delete