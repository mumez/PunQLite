private - actions
openFile
    | filename |
    filename := UITheme builder 
                            fileOpen: 'Choose a .db file' 
                            extensions: #('db').
    filename isNil ifTrue:[ ^self ].
    self openDatabase: filename name