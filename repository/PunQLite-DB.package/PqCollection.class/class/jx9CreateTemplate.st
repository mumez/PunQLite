private templates
jx9CreateTemplate
	^ '
$result = 1;
if(!db_exists("{name}")) \{
	$result = db_create("{name}");
	if (!$result) \{ 
		$errorMessage = db_errlog(); 
	}	
}
'