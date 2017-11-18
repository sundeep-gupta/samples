/**
 * New node file
 */
var child = require('child_process').fork('./child.js');
var server = require('net').createServer();
server.on('connection', function(socket){
	socket.end('Parent handled connection!');
});
server.listen(8080, function(){
	child.send("The parent message!", server);
});