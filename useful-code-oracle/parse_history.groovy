def lines = new File(args[0]).readLines()
def map = [:]
def key = null
def value = 0;
def firstEntry = true;
lines.each { line ->
    if (line.startsWith('DATE: Mar')) {
        key = line
        firstEntry = false
        println "next entry...";
        if (!firstEntry) {
            println "pushed...";
            map[key] = value
            value = 0;
        }
    }
    else if (line.contains('CLOSE_WAIT')) {
        value++;
    }
}
map[key] = value

map.each { k,v ->
    println "${k} is {$v} times."
}
