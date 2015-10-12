pages
pagePerformance
	"This method was automatically generated."
	<script: 'self edit: #pagePerformance'>
	^HelpTopic
		title: 'Performance'
		contents: 
'"Simple store/load round-trip"
	Time millisecondsToRun:[
	db := PqDatabase open: ''bench.db''.
	val := ''0''.
	1 to: 100000 do: [:idx | | key | 
	    key := idx asString.
	    db at: key put: val.
	    val := (db at: key) asString.
	].
	db close.

	]. "===> 877 msecs"


I felt it is quite fast. 100000 round-trips in 877 msecs. Please try the code by yourself.!' readStream nextChunkText