/**
 * New node file
 */
var domain = require('domain');
var fs = require('fs');
var appDomain = domain.create();
appDomain.on('error', function(err){
	console.log("APP Error: ", err);
});

var fsDomain = domain.create();
fsDomain.on('error', function(err){
	console.log("FS Error : ", err);
});

appDomain.run(function(){
	process.nextTick(function() {
		fsDomain.run(function(){
			// fs Domain error here 
			fs.open(__filename, 'r', function(err, fd){
				if (err) {
					throw err;
				}
				// Why am I disposing appDomain in the fsDomain contex ?
				appDomain.dispose();
			});
		});
	});
});