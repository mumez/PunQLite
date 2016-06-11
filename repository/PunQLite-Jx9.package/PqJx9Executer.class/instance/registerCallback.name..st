private
registerCallback: callback name: aString
	"I need to keep callbacks in cache because otehrwise they might be collected by GC, 
	 causing a crash. This way, callbacks will remain as long as executor remains."
	callbackCache ifNil: [ callbackCache := Dictionary new ].
	callbackCache at: aString put: callback