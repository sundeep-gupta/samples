def fname = '/scratch/skgupta/linux-manifest/nls-aix/META-INF/MANIFEST.MF'
def cp = ""
boolean start = false
new File(fname).eachLine { line ->
    if (line.startsWith('Class-path:')) {
        start = true
    }
    if (line.startsWith('Created-By:') ){ start = false}
    if (start) {
       cp += line.trim()
    }
}
cp.tokenize().each { println it}
