/**
 * New node file
 */
var cnt = 0;
var id = setInterval(function(){
	cnt++;
	console.log(cnt + " " + id);
	if (cnt === 10) {
		clearInterval(id);
	}
}, 1000);
id.unref();