def f = args[0]
// '/tmp/foon/META-INF/MANIFEST.MF'
def fLine = ''
new File(f).eachLine { line ->
    if (!fLine.endsWith('.jar') && line.startsWith(' ')) {
        fLine += line.substring(1, line.length())
    }
    else {
    fLine += line
    }
}
def jars = fLine.tokenize(' ').findAll { jarPath ->
    jarPath.endsWith('.jar')
}
jars.each { println it }
