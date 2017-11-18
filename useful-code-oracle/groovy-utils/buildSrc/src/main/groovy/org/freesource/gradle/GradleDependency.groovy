package org.freesource.gradle

class GradleDependency {
    String artifactId
    String groupName
    String version

    String pomFound = false
    String jarFound = false

    public GradleDependency(String groupName, String artifactId, String version) {
        this.groupName = groupName
        this.artifactId = artifactId
        this.version = version
    }
    public boolean equals(GradleDependency dep) {
        return this.artifactId.equals(dep.artifactId) && this.groupName.equals(dep.groupName) && this.version.equals(dep.version)
    }
    public String toString() {
        return "${groupName}:${artifactId}:${version}"
    }
}
