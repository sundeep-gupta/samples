/**
 * New node file
 */
process.on('message', function(msg){
	console.log("Parent said : "+ msg);
	process.send(msg + " too!!!!");
});