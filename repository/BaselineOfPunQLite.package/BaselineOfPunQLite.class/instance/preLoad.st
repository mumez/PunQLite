doits
preLoad
	self platformLibraryName asFileReference exists 
		ifTrue: [ ^ self ].

	ZnClient new
		url: self platformLibraryUrl;
		downloadTo: (FileLocator imageDirectory / self platformLibraryName) fullName.