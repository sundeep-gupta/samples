/*
 * This is example of making any object as EventEmitter and then emit
 * events which are handled by callback methods.
 */
var Emitter = require('event').EventEmitter;
var Counter = function(init) {
    this.increment = function() {
        init++;
	this.emit('incremented', init);
    };
};
// Q: What will happen if i do not associate EventEmitter to Counter
// Will the this.emit method throw some exception ?
Counter.prototype = new Emitter();
var counter = new Counter(10);
var callback = function(count) {
    console.log(count);
};
counter.addListener('incremented', callback);
counter.increment();
counter.increment();
// Q. WHat will happen if I remove listener here and then call increment again ?
