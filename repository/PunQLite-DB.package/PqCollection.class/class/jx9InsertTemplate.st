private templates
jx9InsertTemplate
	^ '
$result = db_store("{name}", $insert);
if (!$result) \{ 
	$errorMessage = db_errlog(); 
}'