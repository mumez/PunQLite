private templates
jx9CreateTemplate
	^ '
if(!db_exists("{name}")) \{
	$result = db_create("{name}");
	if (!$result) \{ 
		$errorMessage = db_errlog(); 
	}	
}
'