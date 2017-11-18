/**
 * This is example of Readable class for asynchronous, non-blocking programming.
 */
var Readable = require('stream').Readable;
var readable = new Readable;
var count = 0;
readable._read = function() {
    if (++count > 10) {
        return readable.push(null);
    }
    setTimeout(function() {
        readable.push(count + "\n");
    }, 500);
};
readable.pipe(process.stdout);
/*
 * To pipe the data to file instead of stdout, you need to do below code
 */
var fs = require('fs');
var writeStream = fs.createWriteStream("./counter", {
	flags : 'w',
        mode: 0666
 	});
 readable.pipe(writeStream);
