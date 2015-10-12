pages
pageUsages5
	"This method was automatically generated."
	<script: 'self edit: #pageUsages5'>
	^HelpTopic
		title: 'Usages 5'
		contents: 
'"Excute Jx9 scripting language"
db := PqDatabase openOnMemory.
src := ''
    $var = 123;
    $str = "$var - one, two, three!!";
    $tm = time();
    ''.
executer := db jx9.
executer evaluate: src.
(executer extract: ''var'') asInt inspect.
(executer extract: ''str'') asString inspect. 
(executer extract: ''tm'') asInt inspect.
executer release.
db close.!' readStream nextChunkText