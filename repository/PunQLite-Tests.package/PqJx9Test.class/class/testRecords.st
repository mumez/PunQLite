accessing
testRecords
	^ { 
		{'name' -> 'John Doe'. 			'age' -> 44. 	'email' -> 'johndoe@mail.net'} asDictionary. 
		{'name' -> 'Jane Smith'. 		'age' -> 37. 	'email' -> 'jane.smith@mail.net'} asDictionary. 
		{'name' -> 'Jimmy Doe-Smith'. 	'age' -> 5. 		'email' -> nil} asDictionary. 
	}