private templates
jx9InsertTemplate
	^ '
$result = db_store("{name}", $insert);
if ($result) \{ 
	$resultId = db_last_record_id("{name}");
} else \{ 
	$errorMessage = db_errlog(); 
}'