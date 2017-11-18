/**
 * New node file
 */
console.log("Child process forked!");
process.on('message', function(msg, server){
	console.log(msg);
	
	require('dgram').createSocket('udp4').send(new Buffer("Hello from client"), 0, 10, 8080, "localhost");
	server.on('connection', function(socket) {
		socket.end("Child handled the connection!");
	});
});