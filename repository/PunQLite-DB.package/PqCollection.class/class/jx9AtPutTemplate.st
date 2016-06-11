private templates
jx9AtPutTemplate
	^ '
$result = db_update_record("{name}", $id, $record);
if (!$result) \{ 
	$errorMessage = db_errlog(); 
}'