private templates
jx9RemoveTemplate
	^ '
$result = db_drop_record("{name}", $id);
if (!$result) \{ 
	$errorMessage = db_errlog(); 
}'