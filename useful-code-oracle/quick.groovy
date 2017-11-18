def zipSize = 0;
def harSize = 0;
new File("/tmp/haronly").eachLine { line ->
    zipSize += new File(line).size()
}
println "Size of all har.zip cumulative is : " + zipSize

