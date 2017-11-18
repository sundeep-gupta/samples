
String getDynamicVersion(String componentVersion) {
    def tokens = componentVersion.tokenize('.')
    def dynamicVer = tokens[0 .. (tokens.size() - 2)].join('.') + '+'
    return dynamicVer
}

void updateProperty(File propFile, String key, String value) {
    def lines = []
    propFile.eachLine { line ->
        if (line.startsWith(key)) {
            lines.add(key + '=' + value)
        }
        else {
            lines.add(line)
        }
    }
    writeFile(propFile, lines)
}

void updateMajorVersion(File propFile, String key, String majorValue) {
    def lines = []
    propFile.eachLine { line ->
        if (line.startsWith(key)) {
            def tokens = line.tokenize('=')[1].tokenize('.')
            tokens[0] = majorValue
            lines.add(key + '=' + tokens.join('.'))
        }
        else {
            lines.add(line)
        }
    }
    writeFile(propFile, lines)
}

def writeFile(File propFile, def lines) {
    propFile.withWriter { writer ->
        lines.each {line ->
            writer.println line
        }
    }
}

def createGitBranch(File repoRoot, String branchName) {
    String command = "cd ${repoRoot.absolutePath}; git checkout -b ${branchName}"
    def output = ["sh", '-c', command].execute().text
    println output
}

def cli = new CliBuilder(usage: 'git-utils --pt-version <testinfraVersion> --repos <location of repository>')
cli._(longOpt: 'pt-version', 'The next release version of TestInfraPlugin', required: true, args: 1)
cli._(longOpt: 'repos', 'The directory location where emdi is cloned', required: true, args:1)
cli._(longOpt: 'help', 'Usage information', required: false)

def options = cli.parse(args)
def repoRoot = new File(options.repos)
def tokens = options.'pt-version'.tokenize('.')
createGitBranch(repoRoot, 'testinfra' + tokens.join('_'))

def localVersion = tokens.join('')
tokens[0] = localVersion

def testinfraComponentVersion = tokens.join('.')
updateProperty(new File(repoRoot,'gradle.properties'), 'testinfraVersion', getDynamicVersion(testinfraComponentVersion))
updateProperty(new File(repoRoot, 'plugins/TestInfraPlugin/gradle.properties'), 'componentVersion', testinfraComponentVersion)

updateMajorVersion(new File(repoRoot, 'tools/lrgmanager/gradle.properties'), 'componentVersion', localVersion)
updateMajorVersion(new File(repoRoot, 'tools/JiraWebServices/gradle.properties'), 'componentVersion', localVersion)
updateMajorVersion(new File(repoRoot, 'tools/ParseLrg/gradle.properties'), 'componentVersion', localVersion)
updateMajorVersion(new File(repoRoot, 'tools/jirasso-library/gradle.properties'), 'componentVersion', localVersion)


