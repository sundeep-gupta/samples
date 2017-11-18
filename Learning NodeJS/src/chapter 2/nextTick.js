/**
 * New node file
 */
var events = require('events');
function getEmitter() {
	var emitter = new events.EventEmitter();
	process.nextTick(function(){
		console.log("Now emitting the start event.");
		emitter.emit('start');
	});
	return emitter;
}

var e = getEmitter();
e.on('start', function() {
	console.log("I'm callback for start event.");
});