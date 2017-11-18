
new File('dependencies').each { line -> 
    def tokens = line.trim().tokenize('/')
    def name = tokens[tokens.size() - 3]
    def version = tokens[tokens.size() - 2]
    def group = tokens[1 .. tokens.size() - 4].join ('.')
    def url = "http://artifactory-slc.oraclecorp.com/artifactory/api/search/latestVersion?g=${group}&a=${name}&v=${version}*&repos=emaas-release-virtual"
    def found = false
    try {
        found = new URL(url).getText().trim()
    }
    catch (Exception e) {
        
    }
    println group + ":" + name + ":" + version +  " is "  + found
}
