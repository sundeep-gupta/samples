def f = new File('/tmp/download_from_sandbox')
if (!f.exists()) {
    println "File ${f.absolutePath} does not exist."
    System.exit(1)
}
def map = [:]
f.eachLine { line ->
    def elem = line.substring(line.lastIndexOf('/') + 1)
    def extn = elem.substring(elem.lastIndexOf('.') + 1)
    def artifactId = elem.substring(0, elem.lastIndexOf('.') )
    if (!map[artifactId]) {
        map[artifactId] = [:]
    }
    else {
        if (map[artifactId].containsKey(extn)) {
            println "WARNING: ${extn} for ${artifactId} already exists and has value : " + map[artifactId][extn]
        }
        map[artifactId][extn] = true
    }
}
println "Doing a lookup of all artifacts downloaded from emaas-sandbox-local"
def sandboxMap = [:]
map.each { rtfId, extnMap ->
    //def repos = ['emaas-sandbox-local', 'thirdparty-release-local']
    def repos = ['emaas-sandbox-local']
    repos.each { repoName ->
        sandboxMap[rtfId] = []
        println "Checking ${rtfId} in ${repoName}"
        def output = ["sh", "-c", "gradle -q -b ~/groovy-utils/build.gradle quickSearch -Pfind=${rtfId} -Prepos=${repoName}"].execute().text.split("\n")
        output.each { line ->
            if (!line.startsWith('http')) {
                return
            }
            sandboxMap[rtfId].add(line.substring(line.lastIndexOf('/') + 1))
        }
        println output
        println ""
    }
    println "-------------------------------------------------------------------------------------------------------------------------"
}
sandboxMap.each { rtfId, files ->
    print "${rtfId} : "
    files.each { file ->
        print "${file} "
    }
    println ""
}
