/**
 * How to test:
 * 1. Run this script as a node program
 * 2. Find its PID
 * 3. Send kill -s SIGUSR1 <pid>
 */
setInterval(function() {}, 1e6);
process.on('SIGUSR1', function(){
	console.log('Got a signal.');
});
