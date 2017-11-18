/**
 * Watches for the events on a file. 
 * NOTE: the file / directory being watched must exist else 'not exists' error (ENOENT) would be thrown.
 * 
 */
var fs = require('fs');
fs.watch(__filename, {persistent:false}, function(event, filename){
	console.log("Event occured " + event + ". On file " + filename);
	
});
setImmediate(function(){
	fs.rename(__filename, __filename + ".new", function(){
		console.log("Callback for rename is called here.");
	});
});
