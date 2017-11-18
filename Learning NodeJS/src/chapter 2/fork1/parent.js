/**
 * New node file
 */
var cp = require('child_process');
var child = cp.fork('./child.js');
child.on('message', function(msg){
	console.log("Child Said:" + msg);
});
child.send("I love you!");