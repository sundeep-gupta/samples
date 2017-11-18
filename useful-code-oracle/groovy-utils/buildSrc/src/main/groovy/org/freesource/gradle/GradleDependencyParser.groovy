package org.freesource.gradle

class GradleDependencyParser {
    def files = []

    def depMap = [:]

    public GradleDependencyParser(ArrayList<File> files) {
        this.files = files
        files.each { file ->
            this.parse(file)
        }
    }

    private void parse(File file) {
        file.eachLine { line ->
            if (line.startsWith('Download http://artifactory')) {
                def tokens = line.tokenize('/')
                def groupName = tokens[4 .. tokens.size() - 4].join('.')
                def artifactId = tokens[tokens.size() - 3]
                def version = tokens[tokens.size() - 2]
                def key = "${groupName}:${artifactId}:${version}"

                GradleDependency dep = null
                if (depMap.containsKey(key)) {
                    dep = depMap.get(key)
                }
                else {
                    dep = new GradleDependency(groupName, artifactId, version)
                    depMap[key] = dep
                }
                if (line.endsWith('.pom')) {
                    dep.pomFound = true
                }
                else if (line.endsWith('.jar')) {
                    dep.jarFound = true
                }
            }
        }
    }
}
